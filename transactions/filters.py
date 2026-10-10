import django_filters

from .models import Transaction


class TransactionFilter(django_filters.FilterSet):
    # example: ?date_from=2026-10-01&date_to=2026-10-09&min_amount=100&status=SUCCESS
    date_from = django_filters.DateFilter(field_name="created_at", lookup_expr="date__gte")
    date_to = django_filters.DateFilter(field_name="created_at", lookup_expr="date__lte")
    min_amount = django_filters.NumberFilter(field_name="amount", lookup_expr="gte")
    max_amount = django_filters.NumberFilter(field_name="amount", lookup_expr="lte")
    status = django_filters.CharFilter(field_name="status", lookup_expr="iexact")

    class Meta:
        model = Transaction
        fields = []
