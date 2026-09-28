# agent-skills

Personal Agent Skills for **Cursor** and **Claude Code**. Install with the [Skills CLI](https://skills.sh/).

## Install

### Globally (all your projects)

```bash
# All skills, Cursor + Claude Code
npx skills add piscis/agent-skills -g -a cursor -a claude-code -y

# Or install everything to all agents
npx skills add piscis/agent-skills --all -g

# Update later
npx skills update -g
```

### A single skill, into one project

Run this from the project root. Omitting `-g` installs at project scope:

```bash
npx skills add piscis/agent-skills --skill conventional-commit -a claude-code -y
```

That writes the skill into the project and records it in `skills-lock.json`:

```
.claude/skills/conventional-commit/SKILL.md
skills-lock.json
```

Commit both, and anyone else on the project gets the same skill. Update it later with
`npx skills update -p`.

For more than one skill, **repeat `--skill`** — a comma-separated list is not accepted:

```bash
npx skills add piscis/agent-skills --skill ask-me --skill ai-review -a claude-code -y
```

Targeting several agents at once (`-a claude-code -a cursor`) installs into
`.agents/skills/<name>/` and symlinks each agent's directory at it, rather than copying into
`.claude/skills/`. Skills with a `references/` directory bring it along either way.

### Preview first

```bash
npx skills add piscis/agent-skills --list
```

## Skill index

| Skill | Description |
| --- | --- |
| [`ai-review`](skills/ai-review/SKILL.md) | Review the current branch PR and post inline findings, after confirmation (GitHub `gh` or Forgejo MCP). |
| [`ask-me`](skills/ask-me/SKILL.md) | Surface only the open questions the user must answer to improve the current plan or task. |
| [`commit-push-pr`](skills/commit-push-pr/SKILL.md) | Create a branch if needed, commit, then push and open a PR after confirmation (GitHub `gh` or Forgejo MCP). |
| [`conventional-commit`](skills/conventional-commit/SKILL.md) | Preview a Conventional Commits message, then commit only after explicit confirmation. |
| [`orpc-api`](skills/orpc-api/SKILL.md) | oRPC + Zod 4 procedure conventions for piscis/fritzbox-cloudflare-dyndns-vercel (schemas, typed error mapping, `/api` catch-all). Auto-applied. |
| [`update-issue`](skills/update-issue/SKILL.md) | Refine an issue title, body, and acceptance criteria, then update after approval (GitHub or Forgejo). |

Invoke explicitly (slash skill / `$skill`) — these use `disable-model-invocation: true`, except `orpc-api`, which the agent applies from context.

## Authoring

See [AGENTS.md](AGENTS.md) for how to add or change skills.
