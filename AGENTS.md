# Agent instructions

This repository contains portable Agent Skills. Keep changes compatible with the open Agent Skills layout and avoid agent-specific duplication when a shared skill works across hosts.

## Repository conventions

- Put every skill under `skills/<skill-name>/`.
- Use lowercase kebab-case for skill directories.
- Keep `SKILL.md` as the agent-facing source of truth.
- Keep each skill's `README.md` human-facing and concise. Don't copy the full workflow from `SKILL.md` into the README.
- Keep the frontmatter `name` aligned with the skill directory name.
- Write descriptions that explain both what the skill does and when it should trigger.
- Put detailed supporting instructions in `references/` and load them only when needed.
- Put deterministic executable helpers in `scripts/` only when they improve reliability.
- Put templates or output assets in `assets/` only when the skill actually needs them.
- Update the root skill catalog when adding or renaming a skill.
- Follow existing repository wording and formatting instead of creating a new convention for each skill.
- Don't add generated archives or packaged skill ZIP files to the repository.
- Don't add agent or tooling attribution to commits, pull requests, or documentation.

## Before committing

Run

```bash
bash ./scripts/validate-skills.sh
```

For any skill that includes executable helpers, run the relevant helper tests or representative executions too.
