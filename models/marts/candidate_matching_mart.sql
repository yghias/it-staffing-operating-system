with ranked_matches as (
    select
        m.*,
        row_number() over (
            partition by m.job_opening_id
            order by m.match_score desc, m.skill_coverage desc, m.technology_coverage desc, m.engineer_id
        ) as match_rank
    from {{ ref('fct_match_score') }} m
)
select
    rm.job_opening_id,
    rm.engineer_id,
    rm.engineer_name,
    rm.match_rank,
    rm.match_score,
    rm.skill_coverage,
    rm.technology_coverage,
    rm.location_score,
    rm.rate_score,
    rm.availability_score,
    rm.freshness_score,
    iff(rm.match_score >= 0.85, 'strong_fit', iff(rm.match_score >= 0.70, 'viable_fit', 'review_required')) as recommendation_band
from ranked_matches rm;
