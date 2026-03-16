# Agent System

The `agents/` layer models the operating workflows that turn raw talent intelligence into recruiter actions, review decisions, and measurable staffing outcomes.

This repository treats agents as production operating units rather than prompt fragments. Each agent includes:

- `config/`: runtime goals, thresholds, and routing controls
- `prompts/`: task-specific prompt templates
- `tools/`: tool contracts and expected inputs and outputs
- `policies/`: approval, escalation, and safety constraints
- `evals/`: golden sets, review rubrics, and quality gates
- `runbooks/`: operating procedures for degraded or low-confidence states
- `artifacts/`: sample outputs and metrics snapshots

## Agent Portfolio

- `recruiter_copilot/`: recruiter-facing search, shortlist, outreach, and submission workflows
- `matching_agent/`: retrieval, reranking, explanation generation, and recommendation quality monitoring
- `review_agent/`: human-in-the-loop triage for entity resolution, candidate suitability, and outbound action approval

## Operating Expectations

- Every recruiter-visible recommendation must be traceable to source evidence.
- Every outbound action requires policy-aware approval routing.
- Every agent has measurable acceptance, latency, and quality thresholds.
- Low-confidence states degrade gracefully into review queues rather than silent failures.
