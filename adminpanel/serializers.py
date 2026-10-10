from rest_framework import serializers

from .models import AdminLog


class DailySummarySerializer(serializers.Serializer):
    day = serializers.DateField()
    total = serializers.IntegerField()
    success = serializers.IntegerField()
    failed = serializers.IntegerField()
    pending = serializers.IntegerField()
    success_amount = serializers.DecimalField(max_digits=14, decimal_places=2, allow_null=True)


class AdminLogSerializer(serializers.ModelSerializer):
    admin = serializers.StringRelatedField()

    class Meta:
        model = AdminLog
        fields = ["id", "admin", "action", "target", "details", "ip_address", "created_at"]
