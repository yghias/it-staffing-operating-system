# Operating Metrics

## Platform KPIs

- `time_to_shortlist_hours`: elapsed time from approved intake to first qualified shortlist
- `match_acceptance_rate`: share of ranked matches accepted into shortlist workflows
- `submission_to_interview_rate`: share of submitted candidates that reach interview stage
- `time_to_fill_days`: elapsed time from opening creation to accepted placement
- `review_queue_sla_attainment`: share of review items resolved within target SLA
- `source_freshness_breach_rate`: share of source feeds outside freshness objectives
- `bench_redeployment_rate`: share of available engineers reassigned within target window
- `gross_margin_percent`: average placement margin by client, desk, and role family

## Reporting Principles

- metrics are defined in SQL and published through curated marts
- warehouse models are the contract for dashboards and executive reporting
- application services do not compute business KPIs independently
