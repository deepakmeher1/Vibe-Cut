from typing import List, Optional
from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.orm import Session
from app.database import get_db
from app.models.template import Template
from app.schemas.template import TemplateResponse, TemplateCreate

router = APIRouter()

@router.get("/", response_model=List[TemplateResponse])
def list_templates(
    category: Optional[str] = None,
    query: Optional[str] = None,
    db: Session = Depends(get_db)
):
    db_query = db.query(Template)
    
    if category and category.lower() != "all":
        db_query = db_query.filter(Template.category.ilike(category))
        
    if query:
        db_query = db_query.filter(Template.title.ilike(f"%{query}%"))
        
    return db_query.all()

@router.post("/", response_model=TemplateResponse, status_code=status.HTTP_201_CREATED)
def create_template(
    template_in: TemplateCreate,
    db: Session = Depends(get_db)
):
    new_template = Template(
        title=template_in.title,
        author=template_in.author,
        views=template_in.views,
        is_ai=template_in.is_ai,
        thumbnail_url=template_in.thumbnail_url,
        category=template_in.category,
        timeline_data=template_in.timeline_data
    )
    db.add(new_template)
    db.commit()
    db.refresh(new_template)
    return new_template

@router.post("/seed", status_code=status.HTTP_200_OK)
def seed_templates(db: Session = Depends(get_db)):
    # Check if templates already exist
    if db.query(Template).first() is not None:
        return {"message": "Templates already seeded"}
        
    default_templates = [
        Template(
            title="Cinematic Video",
            author="GentleGiant Saint",
            views="40.4K",
            is_ai=True,
            thumbnail_url="https://images.unsplash.com/photo-1469474968028-56623f02e42e?q=80&w=300",
            category="Cinematic",
            timeline_data='{"videoClips": [{"id": "v0", "name": "Cinematic Forest", "img": "https://images.unsplash.com/photo-1469474968028-56623f02e42e?q=80&w=300", "startMs": 0, "endMs": 12000, "offsetMs": 0}], "audioClips": [{"id": "a0", "name": "Acoustic Ambient", "startMs": 0, "endMs": 12000, "offsetMs": 0}], "textClips": [{"id": "t0", "name": "Cinematic Intro", "startMs": 0, "endMs": 4000, "offsetMs": 0}], "aspectRatio": "16:9", "totalDurationMs": 12000}'
        ),
        Template(
            title="Sunset template",
            author="Mr. John",
            views="1.3K",
            is_ai=True,
            thumbnail_url="https://images.unsplash.com/photo-1470071459604-3b5ec3a7fe05?q=80&w=300",
            category="AI effects",
            timeline_data='{"videoClips": [{"id": "v0", "name": "Sunset Drone Shot", "img": "https://images.unsplash.com/photo-1470071459604-3b5ec3a7fe05?q=80&w=300", "startMs": 0, "endMs": 8000, "offsetMs": 0}], "audioClips": [{"id": "a0", "name": "Chill Lofi Beat", "startMs": 0, "endMs": 8000, "offsetMs": 0}], "textClips": [{"id": "t0", "name": "Sunset Vibes", "startMs": 1000, "endMs": 5000, "offsetMs": 0}], "aspectRatio": "9:16", "totalDurationMs": 8000}'
        ),
        Template(
            title="Retro Movie recap",
            author="Alex Media",
            views="98.1K",
            is_ai=False,
            thumbnail_url="https://images.unsplash.com/photo-1447752875215-b2761acb3c5d?q=80&w=300",
            category="Cinematic",
            timeline_data='{"videoClips": [{"id": "v0", "name": "Retro Recap", "img": "https://images.unsplash.com/photo-1447752875215-b2761acb3c5d?q=80&w=300", "startMs": 0, "endMs": 15000, "offsetMs": 0}], "audioClips": [{"id": "a0", "name": "Retro Groove", "startMs": 0, "endMs": 15000, "offsetMs": 0}], "textClips": [{"id": "t0", "name": "MEMORIES", "startMs": 2000, "endMs": 10000, "offsetMs": 0}], "aspectRatio": "16:9", "totalDurationMs": 15000}'
        ),
        Template(
            title="Cyberpunk Beats",
            author="VibeFX",
            views="12.5K",
            is_ai=True,
            thumbnail_url="https://images.unsplash.com/photo-1511512578047-dfb367046420?q=80&w=300",
            category="AI effects",
            timeline_data='{"videoClips": [{"id": "v0", "name": "Cyberpunk Neon", "img": "https://images.unsplash.com/photo-1511512578047-dfb367046420?q=80&w=300", "startMs": 0, "endMs": 10000, "offsetMs": 0}], "audioClips": [{"id": "a0", "name": "Synthwave Loop", "startMs": 0, "endMs": 10000, "offsetMs": 0}], "textClips": [{"id": "t0", "name": "NEON SOUL", "startMs": 0, "endMs": 6000, "offsetMs": 0}], "aspectRatio": "1:1", "totalDurationMs": 10000}'
        )
    ]
    db.add_all(default_templates)
    db.commit()
    return {"message": f"Successfully seeded {len(default_templates)} templates"}
