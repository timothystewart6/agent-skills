# Repair Protocol

Use this protocol for any failed local check, CI failure, rebase-introduced failure, Copilot finding, or agent-review finding that may require a code change.

## 1. Reproduce and localize

- Read the complete failure or finding, not only its summary line.
- Reproduce locally when practical.
- Identify the failing behavior, inputs, expected behavior, and actual behavior.
- Trace the failure through the relevant code path and recent diff.
- Check whether the issue already existed on the base branch when that distinction matters.

Do not patch symptoms solely to make a check green.

## 2. Establish root cause

State the concrete root cause internally before editing code.

A root cause should explain why the behavior is wrong and why the proposed change will correct it. Examples include an invalid state transition, incorrect boundary condition, stale assumption, race, missing validation, wrong API contract, incompatible base-branch change, or test fixture that no longer models production behavior.

If the evidence does not establish a root cause, continue investigating before changing code.

## 3. Inspect the repository's testing pattern

Before adding a test, find how nearby behavior is already tested.

- Reuse the existing test framework, directory layout, helpers, fixtures, naming, and assertion style.
- Put the regression test at the lowest useful layer that proves the bug and prevents recurrence.
- Add integration or end-to-end coverage when the defect crosses boundaries and the repository has that testing pattern.
- Do not invent a new testing framework for a single fix.

If the repository truly has no applicable tests or testing pattern, verify the fix with the strongest existing mechanism and record that no applicable automated test pattern exists.

## 4. Write the regression test

For a real bug or regression, add a test that would fail before the fix and pass after it.

When practical, prove the test is meaningful by observing the failure against the buggy behavior before finalizing the fix. Do not damage the working branch solely to manufacture this proof when the failure is already demonstrated by CI or an existing reproducible test.

Add related regression cases when the same root cause can affect adjacent inputs, boundaries, states, permissions, error paths, or variants.

Avoid broad speculative test expansion unrelated to the identified failure.

## 5. Make the smallest correct fix

Change the implementation at the layer that owns the broken behavior.

Avoid

- weakening assertions
- deleting coverage
- suppressing exceptions without handling them
- adding arbitrary retries for deterministic failures
- changing timeouts merely to mask a hang
- special-casing only the failing fixture when production behavior remains wrong
- unrelated refactors mixed into the repair

## 6. Verify locally

Run, in order when applicable

1. the new or focused regression test
2. the affected test file or suite
3. type, lint, build, or static checks affected by the change
4. the repository's broader practical verification

Inspect the diff after verification to ensure the repair did not introduce unrelated edits.

## 7. Commit and push

Commit the repair using the repository's normal convention and push it to the existing PR branch.

Then wait for CI again. A local pass does not replace CI.

## 8. Close the loop

For review feedback, respond when useful with the root cause and fix at a concise technical level. Resolve the conversation only after the fix is pushed and verified, or after documenting why no code change is warranted.

For CI, confirm the previously failing check now passes on the new commit. Do not assume a pushed fix worked without observing the result.
