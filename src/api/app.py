from fastapi import FastAPI

from src.api.routes.health import router as health_router
from src.api.routes.matching import router as matching_router
from src.common.config.settings import get_settings

settings = get_settings()

app = FastAPI(title=settings.app_name)
app.include_router(health_router)
app.include_router(matching_router)
