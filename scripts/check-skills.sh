#!/bin/sh
# Validate the invariants AGENTS.md states but the Skills CLI does not enforce.
# Usage: sh scripts/check-skills.sh
set -u

cd "$(dirname "$0")/.." || exit 1

fail=0
err() { printf '  FAIL %s\n' "$1"; fail=1; }

for dir in skills/*/; do
  name=$(basename "$dir")
  file="$dir/SKILL.md"
  printf '%s\n' "$name"

  [ -f "$file" ] || { err "no SKILL.md"; continue; }

  # Frontmatter must open on line 1 and close again.
  [ "$(head -n 1 "$file")" = "---" ] || err "SKILL.md does not start with '---'"
  if [ "$(grep -c '^---$' "$file")" -lt 2 ]; then
    err "frontmatter is not closed"
    continue
  fi

  fm=$(awk 'NR>1 && /^---$/{exit} NR>1{print}' "$file")

  # name: present, matches the directory, kebab-case, <= 64 chars.
  fm_name=$(printf '%s\n' "$fm" | sed -n 's/^name:[[:space:]]*//p' | head -n 1)
  if [ -z "$fm_name" ]; then
    err "missing 'name:'"
  else
    [ "$fm_name" = "$name" ] || err "name '$fm_name' != directory '$name'"
    [ "${#fm_name}" -le 64 ] || err "name is ${#fm_name} chars (max 64)"
    printf '%s' "$fm_name" | grep -Eq '^[a-z0-9]+(-[a-z0-9]+)*$' \
      || err "name '$fm_name' is not lowercase kebab-case"
  fi

  # description: present and <= 1024 chars (folded block scalars included).
  desc=$(printf '%s\n' "$fm" | awk '
    /^description:/ { inblock=1; sub(/^description:[[:space:]]*(>-|>|\|-|\|)?[[:space:]]*/, ""); if (length($0)) print; next }
    inblock && /^[a-zA-Z0-9_-]+:/ { inblock=0 }
    inblock { print }
  ')
  if [ -z "$(printf '%s' "$desc" | tr -d '[:space:]')" ]; then
    err "missing 'description:'"
  else
    len=$(printf '%s' "$desc" | wc -c | tr -d ' ')
    [ "$len" -le 1024 ] || err "description is $len chars (max 1024)"
  fi

  # Code fences must balance, counting only fences at column 0.
  # A 4-backtick fence legitimately wraps 3-backtick ones, so count the two widths separately.
  for width in '```' '````'; do
    n=$(grep -c "^$width" "$file")
    # Fences of the wider form also match the narrower grep; subtract them.
    if [ "$width" = '```' ]; then
      n=$((n - $(grep -c '^````' "$file")))
    fi
    [ $((n % 2)) -eq 0 ] || err "odd number of '$width' fences ($n) — one is unclosed"
  done

  # Every skill needs a README index row, and vice versa.
  grep -q "skills/$name/SKILL.md" README.md || err "no README skill-index row"
done

for name in $(grep -o 'skills/[a-z0-9-]*/SKILL\.md' README.md | cut -d/ -f2 | sort -u); do
  [ -d "skills/$name" ] || { printf '%s\n' "$name"; err "README lists it but skills/$name/ does not exist"; }
done

if [ "$fail" -eq 0 ]; then
  printf '\nAll skill checks passed.\n'
else
  printf '\nSkill checks FAILED.\n'
fi
exit "$fail"
