# Agent guide — piscis/agent-skills

This repository packages personal workflow skills for Cursor and Claude Code. Humans and agents editing here should follow this guide.

## Layout

```
skills/<skill-name>/SKILL.md     # required
skills/<skill-name>/references/  # optional deep docs (one level deep from SKILL.md)
README.md                        # skill index — keep in sync when adding/removing skills
CLAUDE.md                        # imports AGENTS.md so Claude Code loads these conventions
scripts/check-skills.sh          # enforces the invariants below; run before committing
.forgejo/workflows/validate.yml  # runs the script on push/PR (origin is Forgejo)
renovate.json                    # keeps the workflow's action pins current
```

`scripts/check-skills.sh` checks what the Skills CLI does not: `name` matches the directory,
`name` is kebab-case and ≤64 chars, `description` is present and ≤1024 chars, code fences
balance, and the README index and `skills/` directory agree in both directions.

Skills are discovered under `skills/` by `npx skills`. Do not put `SKILL.md` only at the repo root.

## SKILL.md frontmatter

```yaml
---
name: my-skill          # lowercase, hyphens, max 64 chars; must match directory name
description: >-
  Third-person WHAT + WHEN with trigger phrases (max 1024 chars).
disable-model-invocation: true
---
```

- Default **`disable-model-invocation: true`** for slash-command-style workflows (user-invoked only).
- Omit it only when the agent should auto-apply from ambient context.
- Description is third person, includes **what** the skill does and **when** to use it.

## Body conventions

- Keep `SKILL.md` under ~500 lines. Move long checklists into `references/`.
- First steps should gather context by **running** commands (skills cannot use Cursor `!`shell`` injection).
- Do not rely on Cursor-only frontmatter (`mode:`, `allowed-tools:`). Encode preferences in the body instead.
- Prefer concrete steps, platform branches (GitHub vs Forgejo), and stop conditions.

## Adding a skill

1. `npx skills init skills/my-skill` (or create `skills/my-skill/SKILL.md` by hand).
   The scaffold writes `name: skills/my-skill` verbatim — **fix it to `name: my-skill`**, or the
   frontmatter violates the "must match directory name" rule above.
2. Fill frontmatter + body; set `disable-model-invocation` appropriately.
3. Add a row to the README skill index.
4. Smoke locally:

```bash
sh scripts/check-skills.sh
npx skills add . --list
npx skills add . --skill my-skill -g -a cursor -y
```

5. Commit and push to `origin` (the Forgejo source of truth — see `git remote -v`).
6. Wait for the install mirror to sync, then consumers run `npx skills update -g`.

## Converting Cursor commands

When porting `~/.cursor/commands/*.md`:

1. Add `name:` and keep/enrich `description:`.
2. Add `disable-model-invocation: true` for user-triggered workflows.
3. Replace every `!`command`` context line with an explicit “run this command” step.
4. Drop `mode:` / `allowed-tools:`; describe tool preferences in prose.
5. Preserve the original workflow fidelity (phases, confirmation gates, platform splits).

## Do not

- Hand-edit consumer `skills-lock.json` files in other projects (use `npx skills add/update`).
- Publish internal personal workflows to skills.sh unless intentionally made public.
- Duplicate the same workflow as both a Cursor command and a skill after migration.
