from rest_framework import serializers

from .models import Transaction


class TransactionSerializer(serializers.ModelSerializer):
    class Meta:
        model = Transaction
        fields = ["id", "reference", "card", "card_last4", "amount", "currency",
                  "description", "status", "failure_reason", "created_at", "updated_at"]
        read_only_fields = fields
