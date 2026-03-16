# it-staffing-operating-system

AI-powered IT Staffing Operating System that builds a real-time graph of engineers, skills, technologies, and projects to automatically match, source, and forecast the best technical talent for roles and teams.

The platform vision is to build a Talent Intelligence System that creates a real-time graph of engineers, skills, technologies, projects, recruiters, clients, and job openings to improve matching, sourcing, staffing visibility, and forecasting.

## Repository Overview

- `src/`: application modules for ingestion, transforms, graph construction, matching, forecasting, and APIs.
- `agents/`: recruiter copilot, matching agent, and review policies.
- `sql/`: schema, marts, and data quality tests.
- `models/`: staging, intermediate, and mart model placeholders.
- `docs/`: architecture, governance, security, runbooks, and portfolio-oriented documents.
- `infrastructure/terraform/`: cloud infrastructure scaffold.
- `sample_data/`: starter CSV fixtures for local demos and testing.

## Quick Start

1. Create a Python 3.11 virtual environment.
2. Install dependencies with `pip install -r requirements.txt`.
3. Copy `.env.example` to `.env` and update local values.
4. Run the API with `uvicorn src.api.app:app --reload`.
5. Run tests with `pytest`.

## Core Docs

- [PLAN.md](/Users/yasserghias/Documents/Playground/it-staffing-operating-system/PLAN.md)
- [ARCHITECTURE.md](/Users/yasserghias/Documents/Playground/it-staffing-operating-system/docs/ARCHITECTURE.md)
- [DATA_MODEL.md](/Users/yasserghias/Documents/Playground/it-staffing-operating-system/docs/DATA_MODEL.md)
- [GRAPH_MODEL.md](/Users/yasserghias/Documents/Playground/it-staffing-operating-system/docs/GRAPH_MODEL.md)
- [AI_MATCHING_ENGINE.md](/Users/yasserghias/Documents/Playground/it-staffing-operating-system/docs/AI_MATCHING_ENGINE.md)
- [RUNBOOK.md](/Users/yasserghias/Documents/Playground/it-staffing-operating-system/docs/RUNBOOK.md)

## Scope of This Commit

This repository now includes a production-style starter scaffold with documentation, source modules, SQL assets, CI/CD definitions, sample data, and infrastructure placeholders. It is still intentionally lightweight: connectors, models, and deployment modules are stubs designed to be implemented incrementally without reshaping the repository.
