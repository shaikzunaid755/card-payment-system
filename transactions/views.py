from rest_framework import generics
from rest_framework.permissions import IsAdminUser
from rest_framework.views import APIView

from adminpanel.utils import log_admin_action

from .exports import transactions_to_csv
from .filters import TransactionFilter
from .models import Transaction
from .serializers import TransactionSerializer


class TransactionListView(generics.ListAPIView):
    serializer_class = TransactionSerializer
    filterset_class = TransactionFilter
    ordering_fields = ["created_at", "amount", "status"]

    def get_queryset(self):
        # a user only sees their own history
        return Transaction.objects.filter(user=self.request.user)


class TransactionDetailView(generics.RetrieveAPIView):
    serializer_class = TransactionSerializer

    def get_queryset(self):
        return Transaction.objects.filter(user=self.request.user)


class TransactionExportView(APIView):
    """Admin only. Downloads all transactions as CSV (same filters as the list)."""
    permission_classes = [IsAdminUser]

    def get(self, request):
        queryset = Transaction.objects.select_related("user")
        queryset = TransactionFilter(request.GET, queryset=queryset).qs

        log_admin_action(request, "EXPORT_CSV", "transactions",
                         f"{queryset.count()} rows, filters: {dict(request.GET)}")
        return transactions_to_csv(queryset)
