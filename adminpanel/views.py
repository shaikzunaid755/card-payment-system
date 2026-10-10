from drf_spectacular.utils import OpenApiParameter, extend_schema
from rest_framework import generics
from rest_framework.permissions import IsAdminUser
from rest_framework.response import Response
from rest_framework.views import APIView

from .models import AdminLog
from .serializers import AdminLogSerializer, DailySummarySerializer
from .summary import get_daily_summary


class DailySummaryView(APIView):
    permission_classes = [IsAdminUser]

    @extend_schema(
        parameters=[OpenApiParameter("date_from", str), OpenApiParameter("date_to", str)],
        responses=DailySummarySerializer(many=True),
    )
    def get(self, request):
        rows = get_daily_summary(
            date_from=request.query_params.get("date_from") or None,
            date_to=request.query_params.get("date_to") or None,
        )
        return Response(DailySummarySerializer(rows, many=True).data)


class AdminLogListView(generics.ListAPIView):
    permission_classes = [IsAdminUser]
    serializer_class = AdminLogSerializer
    queryset = AdminLog.objects.select_related("admin")
