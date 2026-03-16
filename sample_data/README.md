# Sample Data

The sample data set is organized to support warehouse model validation, entity resolution checks, and orchestration dry runs.

## Raw source samples

- `raw/ats_candidate.csv`
- `raw/crm_job_opening.csv`
- `raw/project_history.csv`
- `raw/recruiter_activity.csv`
- `raw/placement_history.csv`

These files align with the source contracts defined in [models/sources.yml](../models/sources.yml) and the staging models in [models/staging](../models/staging).

## Control files

- `control/source_row_counts.csv`

This file is used for reconciliation examples and warehouse control-total checks.
