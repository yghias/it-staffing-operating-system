# it-staffing-operating-system

IT Staffing Operating System for building a real-time graph of engineers, skills, technologies, and projects to support matching, sourcing, and talent forecasting.

The platform vision is to build a Talent Intelligence System that creates a real-time graph of engineers, skills, technologies, projects, recruiters, clients, and job openings to improve matching, sourcing, staffing visibility, and forecasting.

## Repository Overview

- `src/`: application modules for ingestion, transforms, graph construction, matching, forecasting, and APIs.
- `agents/`: recruiter, matching, and review agent definitions with configs, prompts, tool specs, evaluations, runbooks, and operating records.
- `sql/`: schema, marts, and data quality tests.
- `models/`: staging, intermediate, and mart model layers.
- `docs/`: architecture, governance, security, runbooks, and portfolio-oriented documents.
- `infrastructure/terraform/`: cloud infrastructure baseline.
- `sample_data/`: lightweight CSV fixtures for local development and testing.

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
- [CLOUD_OPERATIONS.md](/Users/yasserghias/Documents/Playground/it-staffing-operating-system/docs/CLOUD_OPERATIONS.md)
- [RUNBOOK.md](/Users/yasserghias/Documents/Playground/it-staffing-operating-system/docs/RUNBOOK.md)
- [agents/README.md](/Users/yasserghias/Documents/Playground/it-staffing-operating-system/agents/README.md)

## Operating Profile

The repository is organized to look like a scaled staffing platform with:

- controlled agent workflows for recruiter-facing actions
- release thresholds and evaluation assets for ranking systems
- human review queues and audit policies for sensitive decisions
- operating metrics and scorecards representing a multi-desk business in the $5M EBITDA range

## Scope of This Commit

This repository captures the core operating layers behind a staffing platform: documentation, source modules, SQL assets, CI/CD definitions, sample data, infrastructure baselines, and a deeply defined agent layer. The implementation stays compact, but the architecture, controls, workflows, and operating records are meant to reflect a system that has already had to earn trust from recruiters, delivery teams, and leadership.
