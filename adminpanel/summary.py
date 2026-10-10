from django.db.models import Count, Q, Sum
from django.db.models.functions import TruncDate

from transactions.models import Transaction


def get_daily_summary(date_from=None, date_to=None):
    """One row per day: how many payments, how many worked, how much money came in."""
    queryset = Transaction.objects.all()
    if date_from:
        queryset = queryset.filter(created_at__date__gte=date_from)
    if date_to:
        queryset = queryset.filter(created_at__date__lte=date_to)

    status = Transaction.Status
    return (
        queryset.annotate(day=TruncDate("created_at"))
        .values("day")
        .annotate(
            total=Count("id"),
            success=Count("id", filter=Q(status=status.SUCCESS)),
            failed=Count("id", filter=Q(status=status.FAILED)),
            pending=Count("id", filter=Q(status=status.PENDING)),
            success_amount=Sum("amount", filter=Q(status=status.SUCCESS)),
        )
        .order_by("-day")
    )
