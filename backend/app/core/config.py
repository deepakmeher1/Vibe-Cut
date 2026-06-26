from pydantic_settings import BaseSettings

class Settings(BaseSettings):
    API_V1_STR: str = "/api/v1"
    PROJECT_NAME: str = "VibeCut"
    
    # JWT security settings
    JWT_SECRET: str = "9f2b8a7c6e5d4c3b2a1f0e9d8c7b6a5e4d3c2b1a0f9e8d7c6b5a4e3d2c1b0a" # Placeholder secret
    ALGORITHM: str = "HS256"
    ACCESS_TOKEN_EXPIRE_MINUTES: int = 60 * 24 * 7 # 1 week expiration
    
    # Database Settings
    DATABASE_URL: str = "sqlite:///./vibecut.db"

    class Config:
        case_sensitive = True

settings = Settings()
