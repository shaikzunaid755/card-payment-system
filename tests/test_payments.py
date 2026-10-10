"""Tests for the FastAPI payment service. It uses a throwaway SQLite database."""
from datetime import datetime, timedelta, timezone

import jwt
import pytest
from fastapi.testclient import TestClient
from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker
from sqlalchemy.pool import StaticPool

from payment_service import simulator
from payment_service.config import JWT_ALGORITHM, JWT_SECRET_KEY
from payment_service.database import Base, get_db
from payment_service.main import app
from payment_service.models import CardRow, TransactionRow, UserRow

NEXT_YEAR = datetime.now().year + 1


@pytest.fixture
def db_session():
    engine = create_engine("sqlite://", connect_args={"check_same_thread": False},
                           poolclass=StaticPool)
    Base.metadata.create_all(engine)
    session = sessionmaker(bind=engine)()
    yield session
    session.close()


@pytest.fixture
def client(db_session):
    app.dependency_overrides[get_db] = lambda: db_session
    yield TestClient(app)
    app.dependency_overrides.clear()


def make_token(user_id, token_type="access", secret=JWT_SECRET_KEY, minutes=10):
    payload = {
        "user_id": user_id,
        "token_type": token_type,
        "exp": datetime.now(timezone.utc) + timedelta(minutes=minutes),
    }
    return jwt.encode(payload, secret, algorithm=JWT_ALGORITHM)


def auth_header(user_id, **kwargs):
    return {"Authorization": "Bearer " + make_token(user_id, **kwargs)}


@pytest.fixture
def setup_data(db_session):
    """Two users, and one valid card for each."""
    db_session.add_all([
        UserRow(id=1, username="john", is_active=True),
        UserRow(id=2, username="mary", is_active=True),
        CardRow(id=10, user_id=1, last4="1111", expiry_month=12, expiry_year=NEXT_YEAR),
        CardRow(id=20, user_id=2, last4="2222", expiry_month=12, expiry_year=NEXT_YEAR),
    ])
    db_session.commit()


PAYMENT = {"card_id": 10, "amount": "499.50", "description": "Test order"}


def test_health(client):
    assert client.get("/health").json() == {"status": "ok"}


def test_payment_needs_token(client, setup_data):
    # newer FastAPI versions send 401, older ones send 403
    assert client.post("/payments/", json=PAYMENT).status_code in (401, 403)


def test_payment_rejects_fake_token(client, setup_data):
    response = client.post("/payments/", json=PAYMENT,
                           headers={"Authorization": "Bearer not.a.token"})
    assert response.status_code == 401


def test_payment_rejects_wrong_secret(client, setup_data):
    response = client.post("/payments/", json=PAYMENT,
                           headers=auth_header(1, secret="x" * 40))
    assert response.status_code == 401


def test_payment_rejects_refresh_token(client, setup_data):
    response = client.post("/payments/", json=PAYMENT,
                           headers=auth_header(1, token_type="refresh"))
    assert response.status_code == 401


def test_payment_rejects_expired_token(client, setup_data):
    response = client.post("/payments/", json=PAYMENT, headers=auth_header(1, minutes=-5))
    assert response.status_code == 401


def test_payment_rejects_inactive_user(client, setup_data, db_session):
    db_session.query(UserRow).filter(UserRow.id == 1).update({"is_active": False})
    db_session.commit()
    response = client.post("/payments/", json=PAYMENT, headers=auth_header(1))
    assert response.status_code == 401


def test_successful_payment(client, setup_data, db_session, monkeypatch):
    monkeypatch.setattr(simulator, "simulate_payment", lambda: (True, ""))

    response = client.post("/payments/", json=PAYMENT, headers=auth_header(1))

    assert response.status_code == 201
    body = response.json()
    assert body["status"] == "SUCCESS"
    assert body["card_last4"] == "1111"
    assert body["currency"] == "INR"
    saved = db_session.query(TransactionRow).one()
    assert saved.status == "SUCCESS"
    assert saved.user_id == 1


def test_failed_payment_has_reason(client, setup_data, monkeypatch):
    monkeypatch.setattr(simulator, "simulate_payment", lambda: (False, "Insufficient funds"))

    response = client.post("/payments/", json=PAYMENT, headers=auth_header(1))

    assert response.status_code == 201
    assert response.json()["status"] == "FAILED"
    assert response.json()["failure_reason"] == "Insufficient funds"


def test_transaction_starts_as_pending(client, setup_data, db_session, monkeypatch):
    seen = {}

    def fake_simulator():
        # at this moment the row must already be saved as PENDING
        seen["status"] = db_session.query(TransactionRow).one().status
        return True, ""

    monkeypatch.setattr(simulator, "simulate_payment", fake_simulator)
    client.post("/payments/", json=PAYMENT, headers=auth_header(1))

    assert seen["status"] == "PENDING"


def test_cannot_pay_with_someone_elses_card(client, setup_data, db_session):
    response = client.post("/payments/", json={**PAYMENT, "card_id": 20}, headers=auth_header(1))

    assert response.status_code == 404
    assert db_session.query(TransactionRow).count() == 0


def test_unknown_card(client, setup_data):
    response = client.post("/payments/", json={**PAYMENT, "card_id": 999}, headers=auth_header(1))
    assert response.status_code == 404


def test_expired_card_is_rejected(client, setup_data, db_session):
    db_session.add(CardRow(id=30, user_id=1, last4="3333", expiry_month=1, expiry_year=2020))
    db_session.commit()

    response = client.post("/payments/", json={**PAYMENT, "card_id": 30}, headers=auth_header(1))
    assert response.status_code == 400


@pytest.mark.parametrize("bad_amount", ["0", "-5", "abc", "10000000", "10.123"])
def test_invalid_amount(client, setup_data, bad_amount):
    response = client.post("/payments/", json={**PAYMENT, "amount": bad_amount},
                           headers=auth_header(1))
    assert response.status_code == 422


def test_invalid_currency(client, setup_data):
    response = client.post("/payments/", json={**PAYMENT, "currency": "RUPEES"},
                           headers=auth_header(1))
    assert response.status_code == 422


def test_get_payment_by_reference(client, setup_data, monkeypatch):
    monkeypatch.setattr(simulator, "simulate_payment", lambda: (True, ""))
    reference = client.post("/payments/", json=PAYMENT, headers=auth_header(1)).json()["reference"]

    mine = client.get(f"/payments/{reference}", headers=auth_header(1))
    theirs = client.get(f"/payments/{reference}", headers=auth_header(2))

    assert mine.status_code == 200
    assert theirs.status_code == 404


def test_simulator_follows_success_rate(monkeypatch):
    monkeypatch.setattr(simulator, "PAYMENT_SUCCESS_RATE", 1.0)
    assert simulator.simulate_payment() == (True, "")

    monkeypatch.setattr(simulator, "PAYMENT_SUCCESS_RATE", 0.0)
    success, reason = simulator.simulate_payment()
    assert success is False
    assert reason in simulator.FAILURE_REASONS
