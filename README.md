# agent-skills

Personal Agent Skills for **Cursor** and **Claude Code**. Install with the [Skills CLI](https://skills.sh/).

## Install

```bash
# All skills, global, Cursor + Claude Code
npx skills add piscis/agent-skills -g -a cursor -a claude-code -y

# Or install everything to all agents
npx skills add piscis/agent-skills --all -g
```

```bash
# Preview skills without installing
npx skills add piscis/agent-skills --list

# Update after new changes are published
npx skills update -g
```

## Skill index

| Skill | Description |
| --- | --- |
| [`ai-review`](skills/ai-review/SKILL.md) | Review the current branch PR and post inline findings, after confirmation (GitHub `gh` or Forgejo MCP). |
| [`ask-me`](skills/ask-me/SKILL.md) | Surface only the open questions the user must answer to improve the current plan or task. |
| [`commit-push-pr`](skills/commit-push-pr/SKILL.md) | Create a branch if needed, commit, then push and open a PR after confirmation (GitHub `gh` or Forgejo MCP). |
| [`conventional-commit`](skills/conventional-commit/SKILL.md) | Preview a Conventional Commits message, then commit only after explicit confirmation. |
| [`update-issue`](skills/update-issue/SKILL.md) | Refine an issue title, body, and acceptance criteria, then update after approval (GitHub or Forgejo). |

Invoke explicitly (slash skill / `$skill`) — these use `disable-model-invocation: true`.

## Authoring

See [AGENTS.md](AGENTS.md) for how to add or change skills.
