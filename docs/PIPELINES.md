# Pipelines

## Ingestion
- Pull candidate, recruiter, client, and opening records from ATS and CRM systems.
- Ingest resumes, notes, certifications, repositories, and project signals.
- Store raw payloads with source metadata and checkpoints.

## Transformations
- Clean and standardize titles, locations, technologies, skills, and company names.
- Extract entities and evidence from free text.
- Score deterministic and probabilistic identity matches.

## Serving
- Publish curated records into warehouse tables and graph nodes.
- Build embeddings and model features.
- Score candidate-to-opening matches and forecast staffing demand.

## Human Review
- Route low-confidence entity resolution cases to reviewer queues.
- Store approval and rejection feedback for model improvement.
