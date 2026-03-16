# CI/CD

## Build Path

- GitHub Actions validates Python modules, SQL assets, and repository structure on pull requests.
- Container builds are produced for API and orchestration images on protected-branch merges.
- Warehouse deployment steps compile Snowflake models and run data quality checks before promotion.

## Environments

- `dev`: rapid iteration, synthetic or masked data, relaxed concurrency
- `staging`: production-like contracts, release validation, rollback rehearsal
- `prod`: controlled promotion, restricted write access, monitored rollback paths

## Promotion Controls

- no production promotion if warehouse tests fail
- no release if source freshness breaches exceed agreed thresholds
- no scoring promotion without evaluation results and rollback version captured
