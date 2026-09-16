# Contributing

Skills in this repository are meant to stay portable, focused, and easy to install.

## Add a new skill

Create a new directory under `skills/` using lowercase kebab-case.

A typical skill looks like this

```text
skills/example-skill/
  README.md
  SKILL.md
  references/
  scripts/
  assets/
```

Only `SKILL.md` is required by the Agent Skills format. This repository also requires a short `README.md` so people can understand and install a skill without reading its agent instructions.

## SKILL.md

Use YAML frontmatter with a `name` that matches the directory and a description that says what the skill does and when it applies.

Keep the main skill focused on the workflow and non-obvious rules. Move detailed protocols, checklists, and large reference material into `references/` when that keeps the main instructions easier to load and maintain.

## README.md

Use the skill README for human-facing documentation such as

- what the skill is for
- common use cases
- installation
- how to invoke it
- important behavior users should know about

Don't duplicate the full `SKILL.md`. Link to it when someone needs the complete behavior.

## Validation

Run

```bash
bash ./scripts/validate-skills.sh
```

The validator checks the repository's basic skill layout, required frontmatter, matching names, and per-skill README files.

GitHub CLI can also validate skills using its Agent Skills support

```bash
gh skill publish --dry-run
```
