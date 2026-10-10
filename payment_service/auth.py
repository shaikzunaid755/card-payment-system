import jwt
from fastapi import Depends, HTTPException, status
from fastapi.security import HTTPAuthorizationCredentials, HTTPBearer
from sqlalchemy.orm import Session

from payment_service.config import JWT_ALGORITHM, JWT_SECRET_KEY
from payment_service.database import get_db
from payment_service.models import UserRow

bearer_scheme = HTTPBearer()


def get_current_user(
    credentials: HTTPAuthorizationCredentials = Depends(bearer_scheme),
    db: Session = Depends(get_db),
):
    """Checks the access token that Django gave the user and returns that user."""
    unauthorized = HTTPException(
        status_code=status.HTTP_401_UNAUTHORIZED,
        detail="Invalid or expired token",
        headers={"WWW-Authenticate": "Bearer"},
    )

    try:
        payload = jwt.decode(credentials.credentials, JWT_SECRET_KEY, algorithms=[JWT_ALGORITHM])
    except jwt.PyJWTError:
        raise unauthorized

    # refresh tokens must not be accepted here
    if payload.get("token_type") != "access":
        raise unauthorized

    user = db.query(UserRow).filter(UserRow.id == int(payload.get("user_id", 0))).first()
    if user is None or not user.is_active:
        raise unauthorized
    return user
