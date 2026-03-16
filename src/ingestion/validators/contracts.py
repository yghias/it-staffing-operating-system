REQUIRED_CANDIDATE_FIELDS = {"candidate_id", "name"}


def validate_candidate_record(record: dict) -> bool:
    return REQUIRED_CANDIDATE_FIELDS.issubset(record)
