import os
from pathlib import Path

from dotenv import load_dotenv
from sqlalchemy.engine import URL

# use the same .env file as Django (it is in the project root)
BASE_DIR = Path(__file__).resolve().parent.parent
load_dotenv(BASE_DIR / ".env")

# must be the same value that Django uses to sign the tokens
JWT_SECRET_KEY = os.getenv("JWT_SECRET_KEY", "dev-only-shared-jwt-secret-key-change-me-123456")
JWT_ALGORITHM = "HS256"

# chance that a simulated payment succeeds (0.8 = 80%)
PAYMENT_SUCCESS_RATE = float(os.getenv("PAYMENT_SUCCESS_RATE", "0.8"))


def get_database_url():
    # URL.create handles special characters in the password for us
    return URL.create(
        drivername="mysql+pymysql",
        username=os.getenv("DB_USER", "root"),
        password=os.getenv("DB_PASSWORD", ""),
        host=os.getenv("DB_HOST", "127.0.0.1"),
        port=int(os.getenv("DB_PORT", "3306")),
        database=os.getenv("DB_NAME", "card_payment_db"),
    )
