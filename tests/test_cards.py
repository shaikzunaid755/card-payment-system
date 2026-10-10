from datetime import date

import pytest

from cards.models import Card
from cards.utils import detect_brand, luhn_valid, mask_number

pytestmark = pytest.mark.django_db

VISA_NUMBER = "4111111111111111"

CARD_DATA = {
    "cardholder_name": "John Doe",
    "card_type": "CREDIT",
    "card_number": "4111 1111 1111 1111",
    "cvv": "123",
    "expiry_month": 12,
    "expiry_year": date.today().year + 2,
}


def make_card(user, last4="1111"):
    return Card.objects.create(
        user=user, cardholder_name="Test User", card_type="DEBIT", brand="Visa",
        masked_number="**** **** **** " + last4, last4=last4,
        expiry_month=12, expiry_year=date.today().year + 2,
    )


def test_add_card_stores_only_masked_number(auth_client):
    response = auth_client.post("/api/cards/", CARD_DATA)

    assert response.status_code == 201
    assert response.data["last4"] == "1111"
    assert response.data["masked_number"] == "**** **** **** 1111"
    assert response.data["brand"] == "Visa"
    # nothing sensitive in the response
    assert "card_number" not in response.data
    assert "cvv" not in response.data


def test_full_card_number_and_cvv_never_saved(auth_client):
    auth_client.post("/api/cards/", CARD_DATA)

    card = Card.objects.get()
    saved_values = [str(getattr(card, f.name)) for f in Card._meta.fields]
    assert not any(VISA_NUMBER in value for value in saved_values)
    assert not hasattr(card, "cvv")
    assert not hasattr(card, "card_number")


def test_add_card_rejects_bad_luhn(auth_client):
    response = auth_client.post("/api/cards/", {**CARD_DATA, "card_number": "4111111111111112"})
    assert response.status_code == 400
    assert "card_number" in response.data


def test_add_card_rejects_letters(auth_client):
    response = auth_client.post("/api/cards/", {**CARD_DATA, "card_number": "abcd"})
    assert response.status_code == 400


def test_add_card_rejects_bad_cvv(auth_client):
    response = auth_client.post("/api/cards/", {**CARD_DATA, "cvv": "12"})
    assert response.status_code == 400


def test_add_card_rejects_expired(auth_client):
    response = auth_client.post("/api/cards/", {**CARD_DATA, "expiry_year": 2020})
    assert response.status_code == 400


def test_add_card_rejects_far_future_expiry(auth_client):
    response = auth_client.post("/api/cards/", {**CARD_DATA, "expiry_year": date.today().year + 40})
    assert response.status_code == 400


def test_add_card_rejects_bad_name(auth_client):
    response = auth_client.post("/api/cards/", {**CARD_DATA, "cardholder_name": "J0hn <script>"})
    assert response.status_code == 400


def test_add_card_needs_login(api_client):
    assert api_client.post("/api/cards/", CARD_DATA).status_code == 401


def test_list_shows_only_my_cards(auth_client, user, other_user):
    make_card(user, "1111")
    make_card(other_user, "2222")

    response = auth_client.get("/api/cards/")

    assert response.status_code == 200
    assert response.data["count"] == 1
    assert response.data["results"][0]["last4"] == "1111"


def test_delete_my_card(auth_client, user):
    card = make_card(user)
    response = auth_client.delete(f"/api/cards/{card.id}/")
    assert response.status_code == 204
    assert not Card.objects.filter(id=card.id).exists()


def test_cannot_delete_someone_elses_card(auth_client, other_user):
    card = make_card(other_user)
    response = auth_client.delete(f"/api/cards/{card.id}/")
    assert response.status_code == 404
    assert Card.objects.filter(id=card.id).exists()


def test_luhn_check():
    assert luhn_valid(VISA_NUMBER)
    assert not luhn_valid("4111111111111112")


def test_brand_detection():
    assert detect_brand("4111111111111111") == "Visa"
    assert detect_brand("5555555555554444") == "Mastercard"
    assert detect_brand("378282246310005") == "Amex"
    assert detect_brand("6011111111111117") == "Discover"
    assert detect_brand("9999999999999995") == "Unknown"


def test_mask_number():
    assert mask_number(VISA_NUMBER) == "**** **** **** 1111"
