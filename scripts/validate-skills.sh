#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
skills_dir="$repo_root/skills"

failures=0
count=0

fail() {
  printf 'ERROR %s\n' "$*" >&2
  failures=$((failures + 1))
}

if [[ ! -d "$skills_dir" ]]; then
  fail "missing skills directory"
fi

while IFS= read -r -d '' skill_file; do
  count=$((count + 1))
  skill_dir="$(dirname "$skill_file")"
  dir_name="$(basename "$skill_dir")"

  if [[ ! "$dir_name" =~ ^[a-z0-9]+(-[a-z0-9]+)*$ ]]; then
    fail "$dir_name is not lowercase kebab-case"
  fi

  name="$(sed -n '/^---$/,/^---$/ { s/^name:[[:space:]]*//p; }' "$skill_file" | head -n 1 | tr -d '"' | tr -d "'" | sed 's/^[[:space:]]*//; s/[[:space:]]*$//')"

  description="$(sed -n '/^---$/,/^---$/ { s/^description:[[:space:]]*//p; }' "$skill_file" | head -n 1 | sed 's/^[[:space:]]*//; s/[[:space:]]*$//')"

  if [[ -z "$name" ]]; then
    fail "$dir_name has no frontmatter name"
  elif [[ "$name" != "$dir_name" ]]; then
    fail "$dir_name has frontmatter name $name"
  fi

  if [[ -z "$description" ]]; then
    fail "$dir_name has no frontmatter description"
  fi

  if [[ ! -f "$skill_dir/README.md" ]]; then
    fail "$dir_name is missing README.md"
  fi
done < <(find "$skills_dir" -mindepth 2 -maxdepth 2 -type f -name SKILL.md -print0 2>/dev/null)

if [[ "$count" -eq 0 ]]; then
  fail "no skills found"
fi

if [[ "$failures" -ne 0 ]]; then
  printf '%d validation failure(s)\n' "$failures" >&2
  exit 1
fi

printf 'Validated %d skill(s)\n' "$count"
