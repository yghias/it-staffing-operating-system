# Matching Agent

The matching agent owns candidate retrieval, hybrid reranking, and explanation generation for open roles.

## Responsibilities

- combine hard filters, graph traversal, and semantic retrieval
- compute evidence-backed ranking signals
- hand off uncertain recommendations to `review_agent`
- publish weekly scorecards for staffing leadership and talent operations

## Production Signals

- recruiter acceptance rate
- shortlist precision at 5
- explanation completeness
- degraded-mode frequency
