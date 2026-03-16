# Runbook

## Common Operational Tasks
- Re-run a failed ingestion job after connector outage.
- Backfill a source using checkpoint overrides.
- Rebuild graph projections after schema changes.
- Recompute embeddings after taxonomy updates.
- Pause outbound writebacks when downstream systems degrade.

## Incident Priorities

1. restore source freshness for ATS and CRM feeds
2. protect ranking and review workflows from stale or partial data
3. re-publish warehouse marts before resuming downstream automation

## Rollback Notes

- warehouse model releases roll back by restoring the last promoted tag and re-running affected marts
- application releases roll back by re-deploying the last known good image
- scoring configuration rollbacks must restore prior thresholds and evaluation references
