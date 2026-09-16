# Skills

Reusable agent skills for coding and development workflows.

Each skill is self-contained under [`skills/`](skills/) and follows the Agent Skills convention with a required `SKILL.md` file. Human-facing usage notes live in each skill's `README.md`.

## Available skills

| Skill | What it does |
| --- | --- |
| [PR Ready Merge](skills/pr-ready-merge/README.md) | Takes finished work on the current branch through local verification, commit, push, pull request, CI, review, repair, rebase, and squash merge. |

## Install

GitHub CLI can install skills from this repository for a wide range of coding agents.

Install one skill for your current agent

```bash
gh skill install timothystewart6/skills pr-ready-merge --scope user
```

Install it for several agents at user scope

```bash
gh skill install timothystewart6/skills pr-ready-merge \
  --scope user \
  --agent github-copilot \
  --agent codex \
  --agent claude-code
```

Install every skill in the repository

```bash
gh skill install timothystewart6/skills --all --scope user
```

You can also preview a skill before installing it

```bash
gh skill preview timothystewart6/skills pr-ready-merge
```

## Repository layout

```text
skills/
  pr-ready-merge/
    README.md
    SKILL.md
    agents/
    references/
scripts/
  validate-skills.sh
AGENTS.md
CONTRIBUTING.md
README.md
```

`SKILL.md` is the source of truth for agent behavior. A skill's `README.md` is for people and should stay short enough that it doesn't become a second copy of the skill instructions.

## Adding a skill

Create a kebab-case directory under `skills/`, add its `SKILL.md`, and add a short `README.md` for human-facing documentation. Put reusable supporting material in `references/`, executable helpers in `scripts/`, and output assets in `assets/` only when they're needed.

Run the repository validation before opening a pull request

```bash
./scripts/validate-skills.sh
```

See [CONTRIBUTING.md](CONTRIBUTING.md) for the repository conventions.
