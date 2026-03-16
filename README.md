# it-staffing-operating-system

AI-powered IT Staffing Operating System that builds a real-time graph of engineers, skills, technologies, and projects to automatically match, source, and forecast the best technical talent for roles and teams.

The platform vision is to build a Talent Intelligence System that creates a real-time graph of engineers, skills, technologies, projects, recruiters, clients, and job openings to improve matching, sourcing, staffing visibility, and forecasting.

## Repository Overview

- `src/`: application modules for ingestion, transforms, graph construction, matching, forecasting, and APIs.
- `agents/`: production-style recruiter, matching, and review agent definitions with configs, prompts, tool specs, evaluations, runbooks, and operating artifacts.
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
- [agents/README.md](/Users/yasserghias/Documents/Playground/it-staffing-operating-system/agents/README.md)

## Operating Profile

The repository is organized to look like a scaled staffing platform with:

- controlled agent workflows for recruiter-facing actions
- release thresholds and evaluation assets for ranking systems
- human review queues and audit policies for sensitive decisions
- sample operating metrics and scorecards representing a multi-desk business in the $5M EBITDA range

## Scope of This Commit

This repository now includes a production-style starter scaffold with documentation, source modules, SQL assets, CI/CD definitions, sample data, infrastructure placeholders, and a much richer agent operating layer. Core services are still starter implementations, but the repository structure, operating controls, and business-facing artifacts now reflect a scaled staffing platform rather than a blank scaffold.
