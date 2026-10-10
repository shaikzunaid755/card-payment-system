import pytest
from django.contrib.auth import get_user_model

from tests.conftest import PASSWORD, login

User = get_user_model()

pytestmark = pytest.mark.django_db

REGISTER_DATA = {
    "username": "newuser",
    "email": "new@example.com",
    "password": "Str0ng!Passw0rd",
    "confirm_password": "Str0ng!Passw0rd",
}


def test_register_creates_user(api_client):
    response = api_client.post("/api/auth/register/", REGISTER_DATA)

    assert response.status_code == 201
    assert User.objects.filter(username="newuser").exists()
    # the password must never come back in the response
    assert "password" not in response.data


def test_password_is_stored_encrypted(api_client):
    api_client.post("/api/auth/register/", REGISTER_DATA)

    saved_user = User.objects.get(username="newuser")
    assert saved_user.password != "Str0ng!Passw0rd"
    assert saved_user.check_password("Str0ng!Passw0rd")


def test_register_passwords_must_match(api_client):
    data = {**REGISTER_DATA, "confirm_password": "something-else"}
    response = api_client.post("/api/auth/register/", data)
    assert response.status_code == 400


def test_register_rejects_weak_password(api_client):
    data = {**REGISTER_DATA, "password": "12345678", "confirm_password": "12345678"}
    response = api_client.post("/api/auth/register/", data)
    assert response.status_code == 400


def test_register_rejects_duplicate_email(api_client, user):
    data = {**REGISTER_DATA, "email": "JOHN@example.com"}
    response = api_client.post("/api/auth/register/", data)
    assert response.status_code == 400
    assert "email" in response.data


def test_register_rejects_bad_phone(api_client):
    response = api_client.post("/api/auth/register/", {**REGISTER_DATA, "phone": "abc"})
    assert response.status_code == 400


def test_login_returns_tokens(api_client, user):
    response = api_client.post("/api/auth/login/", {"username": "john", "password": PASSWORD})
    assert response.status_code == 200
    assert "access" in response.data and "refresh" in response.data


def test_login_wrong_password(api_client, user):
    response = api_client.post("/api/auth/login/", {"username": "john", "password": "nope"})
    assert response.status_code == 401


def test_protected_route_needs_token(api_client):
    assert api_client.get("/api/auth/me/").status_code == 401


def test_protected_route_with_token(auth_client):
    response = auth_client.get("/api/auth/me/")
    assert response.status_code == 200
    assert response.data["username"] == "john"


def test_protected_route_rejects_fake_token(api_client):
    api_client.credentials(HTTP_AUTHORIZATION="Bearer this.is.fake")
    assert api_client.get("/api/auth/me/").status_code == 401


def test_logout_blacklists_refresh_token(api_client, user):
    tokens = login(api_client, "john")

    response = api_client.post("/api/auth/logout/", {"refresh": tokens["refresh"]})
    assert response.status_code == 200

    # the same refresh token can't be used any more
    refresh_again = api_client.post("/api/auth/token/refresh/", {"refresh": tokens["refresh"]})
    assert refresh_again.status_code == 401


def test_logout_with_bad_token(auth_client):
    response = auth_client.post("/api/auth/logout/", {"refresh": "garbage"})
    assert response.status_code == 400


def test_logout_needs_login(api_client):
    assert api_client.post("/api/auth/logout/", {"refresh": "x"}).status_code == 401
