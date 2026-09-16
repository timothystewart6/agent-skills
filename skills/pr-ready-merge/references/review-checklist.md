# Adversarial Review Checklist

Review the complete PR diff plus enough surrounding code to understand behavior. Look for defects, not stylistic churn.

## Correctness

- Wrong conditions, inverted branches, off-by-one behavior, bad defaults, and invalid state transitions
- Missing null, empty, error, timeout, cancellation, or retry handling
- Incorrect assumptions about ordering, idempotency, uniqueness, concurrency, or persistence
- Partial updates and failure paths that leave inconsistent state
- API or schema contract mismatches
- Incorrect date, time, timezone, numeric, encoding, or serialization behavior

## Regression risk

- Existing behavior unintentionally removed or changed
- Callers that still depend on the previous contract
- Shared helpers whose changed semantics affect unrelated paths
- Migrations or configuration changes that break existing deployments
- Backward compatibility and upgrade or rollback behavior where relevant

## Security and abuse paths

- Missing authorization or ownership checks
- Trusting client-controlled data at privileged boundaries
- Injection, traversal, unsafe deserialization, secret exposure, or logging of sensitive data
- Replay, duplicate submission, race, or privilege-escalation paths
- Resource exhaustion or unbounded user-controlled work

## Reliability

- Races and non-atomic operations
- Retry loops without bounds or idempotency
- Swallowed errors and misleading success states
- Cleanup paths that do not run after failure
- Network and dependency failures that produce corrupt or ambiguous state

## Tests

- Important changed behavior with no coverage despite an existing testing pattern
- Tests that assert implementation details instead of the contract
- Tests that can pass while the bug remains
- Missing negative, boundary, or regression cases suggested by the actual diff

For each suspected issue, inspect the implementation and relevant tests before deciding it is real. Do not create code churn for hypothetical style concerns.

Any real issue that requires a code change must use `repair-protocol.md`, including root-cause analysis, verification, and regression coverage.
