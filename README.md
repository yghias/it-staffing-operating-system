# it-staffing-operating-system

IT Staffing Operating System for building a real-time graph of engineers, skills, technologies, and projects to support matching, sourcing, and talent forecasting.

The platform maintains a real-time graph of engineers, skills, technologies, projects, accounts, and openings to improve matching, sourcing, staffing visibility, and forecasting.

## Repository Overview

- `src/`: application modules for ingestion, transforms, graph construction, matching, forecasting, and APIs.
- `agents/`: staffing workflow agents, review controls, and operating records.
- `sql/`: schema, procedures, marts, reconciliation checks, and warehouse-facing tests.
- `models/`: Snowflake-style staging, intermediate, and mart models.
- `docs/`: architecture, governance, security, runbooks, platform outcomes, and service references.
- `infrastructure/terraform/`: cloud infrastructure baseline.
- `sample_data/`: lightweight CSV fixtures for local development and testing.

## Quick Start

1. Create a Python 3.11 virtual environment.
2. Install dependencies with `pip install -r requirements.txt`.
3. Copy `.env.example` to `.env` and update local values.
4. Run the API with `uvicorn src.api.app:app --reload`.
5. Run tests with `pytest`.

## Core Docs

- [ARCHITECTURE.md](/Users/yasserghias/Documents/Playground/it-staffing-operating-system/docs/ARCHITECTURE.md)
- [DATA_MODEL.md](/Users/yasserghias/Documents/Playground/it-staffing-operating-system/docs/DATA_MODEL.md)
- [GRAPH_MODEL.md](/Users/yasserghias/Documents/Playground/it-staffing-operating-system/docs/GRAPH_MODEL.md)
- [AI_MATCHING_ENGINE.md](/Users/yasserghias/Documents/Playground/it-staffing-operating-system/docs/AI_MATCHING_ENGINE.md)
- [CLOUD_OPERATIONS.md](/Users/yasserghias/Documents/Playground/it-staffing-operating-system/docs/CLOUD_OPERATIONS.md)
- [IMPLEMENTATION_PLAN.md](/Users/yasserghias/Documents/Playground/it-staffing-operating-system/docs/IMPLEMENTATION_PLAN.md)
- [SERVICE_BOUNDARIES.md](/Users/yasserghias/Documents/Playground/it-staffing-operating-system/docs/SERVICE_BOUNDARIES.md)
- [EXECUTIVE_BRIEF.md](/Users/yasserghias/Documents/Playground/it-staffing-operating-system/docs/EXECUTIVE_BRIEF.md)
- [RUNBOOK.md](/Users/yasserghias/Documents/Playground/it-staffing-operating-system/docs/RUNBOOK.md)
- [agents/README.md](/Users/yasserghias/Documents/Playground/it-staffing-operating-system/agents/README.md)

## Operating Profile

The repository is organized around a scaled staffing platform with:

- controlled workflows for desk operations and review-gated actions
- release thresholds and evaluation assets for ranking systems
- human review queues and audit policies for sensitive decisions
- operating metrics and scorecards representing a multi-desk business in the $5M EBITDA range

## Scope of This Commit

This repository captures the core operating layers behind a staffing platform: documentation, source modules, SQL assets, CI/CD definitions, sample data, infrastructure baselines, and workflow controls. The implementation stays compact, but the architecture, controls, warehouse models, and operating records are structured like an internal platform repository intended for continued operation and extension.
