# Executive Brief

## Scope

`it-staffing-operating-system` consolidates staffing demand, engineer supply, placement performance, and technical fit scoring into a single operational platform. The repository is organized around warehouse-first modeling, deterministic controls in SQL, and thin Python services for ingestion, orchestration, and APIs.

## Primary Consumers

- delivery operations tracking supply and redeployment risk
- account teams managing open demand and staffing velocity
- platform engineering maintaining pipelines, data contracts, and runtime controls
- staffing leadership reviewing pipeline health, margin exposure, and fill-rate performance

## Operating Priorities

- shorten time from intake to qualified shortlist
- reduce avoidable review churn caused by poor intake quality
- make ranking decisions explainable and auditable
- centralize reporting logic in Snowflake rather than reimplementing metrics in application code
