# Low Confidence Shortlist Runbook

## Trigger
Shortlist confidence falls below the configured candidate-match threshold or evidence density is insufficient.

## Actions
1. Block outbound submission and outreach writeback.
2. Route the case to `review_agent`.
3. Surface missing evidence fields to the recruiter.
4. Log the cause category for later model analysis.

## Exit Criteria
- recruiter approves the shortlist manually, or
- fresh evidence raises the confidence score above threshold
