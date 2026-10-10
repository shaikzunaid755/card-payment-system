from datetime import timedelta
from decimal import Decimal

import pytest
from django.utils import timezone

from adminpanel.models import AdminLog
from transactions.exports import safe_cell
from transactions.models import Transaction

pytestmark = pytest.mark.django_db


def make_transaction(user, amount="100.00", status="SUCCESS", days_ago=0, reference=None):
    transaction = Transaction.objects.create(
        reference=reference or f"ref-{Transaction.objects.count() + 1}",
        user=user, card_last4="1111", amount=Decimal(amount), status=status,
    )
    if days_ago:
        # auto_now_add ignores values we pass in, so we update the date afterwards
        Transaction.objects.filter(pk=transaction.pk).update(
            created_at=timezone.now() - timedelta(days=days_ago))
    return transaction


def test_history_shows_only_my_transactions(auth_client, user, other_user):
    make_transaction(user)
    make_transaction(other_user)

    response = auth_client.get("/api/transactions/")

    assert response.status_code == 200
    assert response.data["count"] == 1


def test_history_needs_login(api_client):
    assert api_client.get("/api/transactions/").status_code == 401


def test_filter_by_status(auth_client, user):
    make_transaction(user, status="SUCCESS")
    make_transaction(user, status="FAILED")

    response = auth_client.get("/api/transactions/?status=failed")

    assert response.data["count"] == 1
    assert response.data["results"][0]["status"] == "FAILED"


def test_filter_by_amount(auth_client, user):
    make_transaction(user, amount="50.00")
    make_transaction(user, amount="500.00")
    make_transaction(user, amount="5000.00")

    response = auth_client.get("/api/transactions/?min_amount=100&max_amount=1000")

    assert response.data["count"] == 1
    assert Decimal(response.data["results"][0]["amount"]) == Decimal("500.00")


def test_filter_by_date(auth_client, user):
    make_transaction(user, days_ago=10)
    make_transaction(user, days_ago=0)
    start = (timezone.now() - timedelta(days=2)).date().isoformat()

    response = auth_client.get(f"/api/transactions/?date_from={start}")
    assert response.data["count"] == 1

    end = (timezone.now() - timedelta(days=5)).date().isoformat()
    response = auth_client.get(f"/api/transactions/?date_to={end}")
    assert response.data["count"] == 1


def test_transaction_detail_is_private(auth_client, user, other_user):
    mine = make_transaction(user)
    theirs = make_transaction(other_user)

    assert auth_client.get(f"/api/transactions/{mine.id}/").status_code == 200
    assert auth_client.get(f"/api/transactions/{theirs.id}/").status_code == 404


def test_export_is_admin_only(auth_client):
    assert auth_client.get("/api/transactions/export/").status_code == 403


def test_admin_can_export_csv_and_it_is_logged(admin_client, user):
    make_transaction(user, amount="250.00", reference="abc-123")

    response = admin_client.get("/api/transactions/export/")

    assert response.status_code == 200
    assert response["Content-Type"] == "text/csv"
    content = response.content.decode()
    assert "Reference,User,Card,Amount" in content
    assert "abc-123" in content
    assert AdminLog.objects.filter(action="EXPORT_CSV").count() == 1


def test_export_respects_filters(admin_client, user):
    make_transaction(user, status="SUCCESS", reference="good-one")
    make_transaction(user, status="FAILED", reference="bad-one")

    content = admin_client.get("/api/transactions/export/?status=FAILED").content.decode()

    assert "bad-one" in content
    assert "good-one" not in content


def test_csv_injection_is_blocked():
    assert safe_cell("=SUM(A1:A9)") == "'=SUM(A1:A9)"
    assert safe_cell("normal text") == "normal text"
    assert safe_cell("") == ""
