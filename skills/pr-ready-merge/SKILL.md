---
name: pr-ready-merge
description: Take the current local Git branch from finished implementation through verification, commit, push, pull request creation, CI repair, code review, final rebase, conversation resolution, and squash merge. Use when the user asks to finish, ship, PR, review, validate, or merge work that already exists in a local Git repository. The workflow verifies the actual diff, runs the repository's existing checks, diagnoses failures to root cause, adds regression tests for real bugs, optionally requests GitHub Copilot review exactly once, can perform an independent adversarial review, waits for CI, and merges only after all gates are clean.
---

# PR Ready Merge

Drive the current branch from local work to a clean merged pull request without bypassing repository safeguards.

## Start

Before changing the repository, determine the repository root, current branch, working tree state, configured remotes, and likely base branch.

Ask one review-mode question unless the user already selected a mode in the same request.

1. Copilot review
2. Agent review
3. Copilot + agent review

Explain the choices briefly if needed.

- Copilot review requests GitHub Copilot exactly once using GitHub's normal reviewer mechanism. If that one request fails, do not retry it. Perform the agent review instead.
- Agent review skips Copilot and performs the adversarial review in `references/review-checklist.md`.
- Copilot + agent review requests Copilot once, handles its review, then performs the adversarial agent review before final merge gates.

Never silently choose a review mode.

## Non-negotiable rules

- Stay on the current branch unless a temporary detached state is required for inspection. Never silently create or switch to a different feature branch.
- Never discard, reset, overwrite, or hide user changes to make the branch appear clean.
- Never weaken tests, lower coverage thresholds, skip required checks, or bypass branch protections to obtain a green result.
- Never use an admin override to merge.
- Never request Copilot review more than once for the PR, including after later pushes.
- Never treat a review comment as a required code change without investigating whether it identifies a real issue.
- Never mark a bug fixed until its root cause is understood and the fix is verified.
- For every real bug, regression, CI defect, or review finding that changes code, add a regression test that would have caught it when the repository has an applicable testing pattern. Add related regression cases when the same root cause can affect adjacent behavior.
- Prefer the smallest correct fix. Do not perform unrelated cleanup while repairing a failure.
- Preserve the repository's existing conventions for commits, tests, pull requests, labels, and merge policy unless the user explicitly overrides them.
- Do not add AI, agent, Copilot, Claude, Codex, or similar co-author trailers to commits.

## Workflow

### 1. Inspect the branch

Inspect the current branch before modifying anything.

- Confirm this is a Git repository.
- Record the current branch and HEAD.
- Inspect staged, unstaged, and untracked files.
- Inspect the diff against the likely base branch.
- Look for accidental secrets, generated files, debug output, unrelated edits, merge artifacts, or obviously incomplete work.
- Determine the repository's existing verification commands from its documentation, package scripts, CI definitions, task runner, Makefile, or established local conventions.
- Determine the repository's normal base branch and PR conventions from GitHub metadata when possible.

If the current branch is the base branch or the intended work cannot be distinguished from unrelated local changes, stop in a blocked state rather than inventing intent.

### 2. Verify the local implementation

Run the relevant local verification already established by the repository. This can include unit tests, integration tests, linting, formatting checks, type checks, builds, generated-file checks, schema validation, security checks, or repository-specific verification commands.

Select checks based on the actual diff and repository patterns. Run the broadest practical existing verification before opening the PR.

If anything fails, follow `references/repair-protocol.md` before continuing.

### 3. Commit and push

Once local verification is green, commit all intended local changes that belong to this branch.

- Use the repository's commit-message convention when one exists.
- If multiple local commits already exist, do not rewrite them merely for aesthetics.
- Confirm the working tree is clean after committing, except for intentionally ignored files.
- Push the current branch to its configured remote. Set upstream if needed.

Do not include unrelated files in the commit.

### 4. Open or reuse the pull request

Check whether the current branch already has an open PR.

- Reuse the existing open PR when one exists.
- Otherwise create one against the repository's normal base branch.
- Build the title and body from the actual diff and repository conventions.
- Keep the description concise and factual.
- Do not add AI attribution or tooling attribution.

Record the PR number and URL for all later steps.

### 5. Wait for CI

Wait for all required and relevant PR checks to reach a terminal state. Prefer GitHub's check-watching mechanism when available.

If any check fails, follow `references/repair-protocol.md`, push the fix, and wait for the new CI run. Repeat until CI is green or the failure is clearly external and cannot be corrected from the repository.

Do not dismiss a failing check as flaky without evidence. If retrying is justified by a documented transient infrastructure failure, record why. Do not repeatedly rerun a deterministic failure instead of fixing it.

### 6. Perform the selected review mode

#### Copilot review

Request GitHub Copilot through GitHub's standard reviewer request mechanism. With GitHub CLI, prefer the supported reviewer form such as `gh pr edit <number> --add-reviewer @copilot` when available in the installed version.

Attempt the Copilot review request exactly once.

- If the request succeeds, set a permanent internal state that Copilot has been requested. Never request it again for this PR.
- Poll for the review once every 60 seconds.
- Continue polling until Copilot posts a review or GitHub provides a terminal condition showing the review cannot occur.
- If the single request itself fails, do not retry it. Switch to the agent review.

When Copilot review arrives, inspect every finding. For each finding, determine whether it identifies a real bug, regression, logic error, security issue, edge case, maintainability defect with correctness impact, or a false or irrelevant concern.

For every real issue, follow `references/repair-protocol.md`.

For an incorrect or irrelevant finding, leave the code unchanged. Respond with concise technical reasoning when a response is useful.

After addressing Copilot feedback, never request Copilot again, even after pushing more commits.

#### Agent review

Perform the adversarial review in `references/review-checklist.md` against the complete PR diff and relevant surrounding code.

Investigate every issue found. For every real issue, follow `references/repair-protocol.md`.

#### Copilot + agent review

Complete the Copilot review flow first. Then perform the full agent review against the updated branch. Do not request Copilot again after agent fixes.

### 7. Reverify after review fixes

If review produced any code changes

- Run the focused regression tests added for each fix.
- Run the affected test suites.
- Run the repository's broader practical verification again.
- Push the commits.
- Wait for CI to become green again.

If CI fails after review fixes, follow the repair protocol and repeat until green.

### 8. Rebase onto the latest base branch

Immediately before final merge gates, fetch the remote base branch and determine whether the PR branch is behind it.

If it is behind

- Rebase the current branch onto the latest remote base branch.
- Resolve conflicts by preserving both the intended feature behavior and the current base behavior. Investigate conflicts rather than mechanically choosing one side.
- Run the relevant local verification again after the rebase.
- Push the rebased branch with `--force-with-lease`, never a blind force push.

If branch protection prevents the required rebase push, stop in a blocked state. Do not substitute a merge commit or admin override unless the user explicitly changes the requirement.

Any rebase that changes the PR commit SHA requires a fresh CI run. Wait for that CI to finish and repair any real failures using the same protocol.

### 9. Resolve review conversations

Inspect all PR review threads and conversations.

- Ensure every actionable finding has been addressed or technically answered.
- Ensure fixes have corresponding regression coverage when an applicable testing pattern exists.
- Resolve completed conversations through GitHub's supported API or UI mechanism.
- Do not resolve a conversation that still contains an unresolved actionable issue.

The final state must contain no unresolved actionable review conversations.

### 10. Final merge gates

Before merging, verify all of the following against the current PR head.

- Working tree is clean.
- Local branch is based on the latest required base branch after the final rebase.
- Required CI is green.
- Relevant non-required checks are not hiding a known defect.
- Selected review mode completed, or Copilot request failed and the required agent fallback review completed.
- Copilot was requested no more than once.
- Every real review finding was investigated to root cause.
- Every code fix was verified locally.
- Regression tests were added for fixes when the repository has an applicable testing pattern.
- No unresolved actionable review conversations remain.
- GitHub reports the PR mergeable under normal repository rules.

If any gate is false, do not merge.

### 11. Squash merge

Merge using the repository's normal GitHub mechanism with squash merge. Do not use rebase-merge for the final PR merge. The branch itself has already been rebased onto the latest base branch when necessary.

Use the repository's normal squash commit title and message conventions. Do not add AI or agent attribution.

Confirm GitHub reports the PR merged successfully.

## Repair protocol

Read `references/repair-protocol.md` whenever CI, tests, rebase behavior, Copilot feedback, or the agent review identifies a possible defect.

## Progress updates

For long-running workflows, provide short progress updates at meaningful transitions such as local verification complete, PR opened, CI failure root cause found, review received, review fixes pushed, final CI green, and PR merged.

Do not claim a check, review, conversation resolution, rebase, or merge succeeded until its actual result has been observed.

## Completion output

After a successful merge, report concisely

- PR title and URL
- final merge result
- review mode used
- substantive bugs or regressions fixed during CI or review, if any
- regression tests added, if any

If blocked, report the exact blocking condition, what has already passed, and the next action needed. Do not describe an incomplete PR as ready or merged.
