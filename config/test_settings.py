# Settings used only when running tests, so you do not need MySQL to run them.
from .settings import *  # noqa

DATABASES = {
    "default": {
        "ENGINE": "django.db.backends.sqlite3",
        "NAME": ":memory:",
    }
}

# faster password hashing so the tests run quickly
PASSWORD_HASHERS = ["django.contrib.auth.hashers.MD5PasswordHasher"]
