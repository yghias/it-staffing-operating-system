from dataclasses import dataclass


@dataclass
class EmbeddingRequest:
    document_id: str
    content: str


def build_embedding_payload(request: EmbeddingRequest) -> dict[str, str]:
    return {
        "document_id": request.document_id,
        "content": request.content,
    }
