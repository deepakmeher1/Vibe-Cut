from datetime import datetime
from typing import Optional
from pydantic import BaseModel, ConfigDict

class ProjectBase(BaseModel):
    name: str
    duration: Optional[str] = "00:00"
    size: Optional[str] = "0MB"
    thumbnail: Optional[str] = None
    timeline_data: Optional[str] = None # Stores serialized timeline tracks

class ProjectCreate(ProjectBase):
    pass

class ProjectUpdate(BaseModel):
    name: Optional[str] = None
    duration: Optional[str] = None
    size: Optional[str] = None
    thumbnail: Optional[str] = None
    timeline_data: Optional[str] = None

class ProjectResponse(ProjectBase):
    id: int
    created_at: datetime
    updated_at: datetime
    owner_id: int

    model_config = ConfigDict(from_attributes=True)
