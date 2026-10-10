import pytest
from django.contrib.auth import get_user_model
from rest_framework.test import APIClient

User = get_user_model()

PASSWORD = "StrongPass#2026"


@pytest.fixture
def api_client():
    return APIClient()


@pytest.fixture
def user(db):
    return User.objects.create_user(username="john", email="john@example.com", password=PASSWORD)


@pytest.fixture
def other_user(db):
    return User.objects.create_user(username="mary", email="mary@example.com", password=PASSWORD)


@pytest.fixture
def admin_user(db):
    return User.objects.create_superuser(username="boss", email="boss@example.com",
                                         password=PASSWORD)


def login(client, username):
    """Logs in through the real login endpoint and sets the Bearer token."""
    response = client.post("/api/auth/login/", {"username": username, "password": PASSWORD})
    client.credentials(HTTP_AUTHORIZATION="Bearer " + response.data["access"])
    return response.data


@pytest.fixture
def auth_client(api_client, user):
    login(api_client, "john")
    return api_client


@pytest.fixture
def admin_client(admin_user):
    client = APIClient()
    login(client, "boss")
    return client
