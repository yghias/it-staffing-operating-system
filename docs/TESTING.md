# Testing

## Automated Checks

- Unit tests for normalization, entity resolution, warehouse handoff logic, and scoring helpers.
- Integration tests for connector contracts, graph construction, and SQL-backed ranking entrypoints.
- End-to-end tests for match scoring API paths and orchestration payloads.
- Data tests for schema constraints, referential integrity, mart freshness, and scoring bounds.

## Warehouse Validation

- staging models must satisfy uniqueness and nullability checks on business keys
- mart outputs must keep score ranges and SLA metrics within expected bounds
- reconciliation checks compare open-demand counts against source-system control totals

## Release Criteria

- CI must pass Python checks and SQL lint or validation steps
- warehouse model changes require mart-level impact review
- scoring changes require evaluation baselines before promotion
