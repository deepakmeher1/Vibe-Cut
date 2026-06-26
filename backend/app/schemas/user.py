from typing import Optional
from pydantic import BaseModel, ConfigDict

class UserBase(BaseModel):
    email: str
    name: Optional[str] = None

class UserRegister(UserBase):
    password: str

class UserLogin(BaseModel):
    email: str
    password: str

class UserResponse(UserBase):
    id: int
    is_active: bool

    model_config = ConfigDict(from_attributes=True)

class Token(BaseModel):
    access_token: str
    token_type: str

class TokenData(BaseModel):
    user_id: Optional[str] = None
