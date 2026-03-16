# API Integrations

## Planned Connectors
- ATS: Bullhorn, Greenhouse, Lever
- CRM: Salesforce, HubSpot
- HRIS: Workday, BambooHR
- Engineering systems: GitHub, GitLab, Jira
- Communication systems: Slack, email delivery providers

## Integration Standards
- Use source-specific adapters behind a normalized ingestion contract.
- Store source-native IDs and sync checkpoints.
- Keep read and writeback operations isolated for auditability.
