# PR Ready Merge

Takes finished work on the current Git branch and drives it through verification, pull request creation, CI, review, repair, final rebase, and squash merge.

The full agent workflow lives in [`SKILL.md`](SKILL.md).

## What it handles

- inspects the current branch and diff before changing anything
- runs the repository's existing local verification
- commits and pushes intended local changes after verification passes
- opens a pull request or reuses the existing one
- waits for CI and investigates failures to root cause
- writes regression tests for real fixes when the repository has an applicable test pattern
- defaults to adversarial agent review; Copilot review requires explicit user opt-in
- requests Copilot review at most once
- falls back to adversarial agent review if the Copilot request fails
- rebases onto the latest base branch before final merge gates when needed
- resolves completed review conversations
- squash merges only after the branch is clean and all required gates pass

## Review modes

**Agent review is the default.** The skill does not ask a review-mode question for ordinary PR, validation, or merge work.

- **Agent review (default):** Run the adversarial agent review without requesting GitHub Copilot.
- **Copilot review (explicit opt-in):** Request it only when the user explicitly asks for Copilot to review the current PR.
- **Copilot + agent review (explicit opt-in):** Perform both only when the user explicitly asks for both.

An open PR, existing review comments, or a normal request to ship work is not permission to request Copilot. If requested, the Copilot reviewer is asked at most once through GitHub's normal mechanism.

## Repair behavior

A failing check or valid review finding isn't treated as fixed just because the immediate symptom disappears. The skill identifies the root cause, makes the smallest correct fix, verifies it locally, and adds tests that would have caught the problem when the repository already has an applicable testing pattern.

See [`references/repair-protocol.md`](references/repair-protocol.md) for the detailed repair rules.

## Install

Install globally for the current agent

```bash
gh skill install timothystewart6/agent-skills pr-ready-merge --scope user
```

Install for GitHub Copilot, Codex, and Claude Code

```bash
gh skill install timothystewart6/agent-skills pr-ready-merge \
  --scope user \
  --agent github-copilot \
  --agent codex \
  --agent claude-code
```

## Use

Ask the agent to finish or ship the current branch, or invoke the skill explicitly when the agent supports explicit skill selection.

Examples

```text
Get this branch ready and merge the PR.
```

```text
Finish this work, use Copilot + agent review, and merge it when everything is clean.
```
