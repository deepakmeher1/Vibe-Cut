from sqlalchemy import Boolean, Column, Integer, String, Text
from app.database import Base

class Template(Base):
    __tablename__ = "templates"

    id = Column(Integer, primary_key=True, index=True)
    title = Column(String, index=True, nullable=False)
    author = Column(String, nullable=False)
    views = Column(String, default="0")
    is_ai = Column(Boolean, default=False)
    thumbnail_url = Column(String, nullable=False)
    category = Column(String, index=True, default="All")
    
    # Pre-structured timeline segments for the template
    timeline_data = Column(Text, nullable=True)
