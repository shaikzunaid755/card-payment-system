from decimal import Decimal

import pytest
from django.contrib.admin.sites import site
from django.test import Client

from adminpanel.models import AdminLog
from adminpanel.summary import get_daily_summary
from cards.models import Card
from transactions.models import Transaction

pytestmark = pytest.mark.django_db


@pytest.fixture
def some_transactions(user):
    for i, (amount, status) in enumerate([("100.00", "SUCCESS"), ("200.00", "SUCCESS"),
                                          ("300.00", "FAILED"), ("400.00", "PENDING")]):
        Transaction.objects.create(reference=f"r{i}", user=user, card_last4="1111",
                                   amount=Decimal(amount), status=status)


def test_daily_summary_numbers(some_transactions):
    rows = list(get_daily_summary())

    assert len(rows) == 1
    assert rows[0]["total"] == 4
    assert rows[0]["success"] == 2
    assert rows[0]["failed"] == 1
    assert rows[0]["pending"] == 1
    assert rows[0]["success_amount"] == Decimal("300.00")


def test_daily_summary_date_range(some_transactions):
    assert list(get_daily_summary(date_from="2999-01-01")) == []


def test_daily_summary_api_is_admin_only(auth_client, admin_client, some_transactions):
    assert auth_client.get("/api/admin/daily-summary/").status_code == 403

    response = admin_client.get("/api/admin/daily-summary/")
    assert response.status_code == 200
    assert response.data[0]["total"] == 4


def test_admin_logs_api(auth_client, admin_client):
    AdminLog.objects.create(action="TEST", target="x")

    assert auth_client.get("/api/admin/logs/").status_code == 403
    assert admin_client.get("/api/admin/logs/").status_code == 200


def test_admin_site_pages_open(admin_user, user, some_transactions):
    client = Client()
    client.force_login(admin_user)

    for url in ["/admin/", "/admin/accounts/user/", "/admin/cards/card/",
                "/admin/transactions/transaction/", "/admin/adminpanel/adminlog/",
                "/admin/adminpanel/dailysummary/"]:
        assert client.get(url).status_code == 200, url


def test_admin_changes_are_logged(admin_user, user):
    client = Client()
    client.force_login(admin_user)

    client.post(f"/admin/accounts/user/{user.pk}/delete/", {"post": "yes"})

    assert AdminLog.objects.filter(action="DELETE").exists()


def test_admin_csv_action(admin_user, user, some_transactions):
    client = Client()
    client.force_login(admin_user)
    ids = list(Transaction.objects.values_list("pk", flat=True))

    response = client.post("/admin/transactions/transaction/", {
        "action": "export_selected_as_csv",
        "_selected_action": ids,
    })

    assert response.status_code == 200
    assert response["Content-Type"] == "text/csv"
    assert AdminLog.objects.filter(action="EXPORT_CSV").exists()


def test_cards_are_read_only_in_admin():
    card_admin = site._registry[Card]
    assert card_admin.has_add_permission(None) is False
    assert card_admin.has_change_permission(None) is False
