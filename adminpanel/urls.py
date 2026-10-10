from django.urls import path

from .views import AdminLogListView, DailySummaryView

urlpatterns = [
    path("daily-summary/", DailySummaryView.as_view(), name="daily-summary"),
    path("logs/", AdminLogListView.as_view(), name="admin-logs"),
]
