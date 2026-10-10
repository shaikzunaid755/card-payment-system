from django.urls import path

from .views import TransactionDetailView, TransactionExportView, TransactionListView

urlpatterns = [
    path("", TransactionListView.as_view(), name="transaction-list"),
    # keep "export/" above "<int:pk>/" so it is matched first
    path("export/", TransactionExportView.as_view(), name="transaction-export"),
    path("<int:pk>/", TransactionDetailView.as_view(), name="transaction-detail"),
]
