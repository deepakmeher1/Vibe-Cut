from typing import Optional
from pydantic import BaseModel, ConfigDict

class TemplateBase(BaseModel):
    title: str
    author: str
    views: Optional[str] = "0"
    is_ai: Optional[bool] = False
    thumbnail_url: str
    category: Optional[str] = "All"
    timeline_data: Optional[str] = None

class TemplateCreate(TemplateBase):
    pass

class TemplateResponse(TemplateBase):
    id: int

    model_config = ConfigDict(from_attributes=True)
