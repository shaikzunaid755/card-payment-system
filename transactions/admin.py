from django.contrib import admin

from adminpanel.mixins import LogActionsMixin
from adminpanel.utils import log_admin_action

from .exports import transactions_to_csv
from .models import Transaction


@admin.register(Transaction)
class TransactionAdmin(LogActionsMixin, admin.ModelAdmin):
    list_display = ["reference", "user", "card_last4", "amount", "currency",
                    "status", "created_at"]
    list_filter = ["status", "created_at", "currency"]
    search_fields = ["reference", "user__username", "user__email", "card_last4"]
    date_hierarchy = "created_at"
    actions = ["export_selected_as_csv"]

    # transactions come from the payment service, so nobody edits them by hand
    def has_add_permission(self, request):
        return False

    def has_change_permission(self, request, obj=None):
        return False

    def has_delete_permission(self, request, obj=None):
        return False

    @admin.action(description="Export selected transactions to CSV")
    def export_selected_as_csv(self, request, queryset):
        log_admin_action(request, "EXPORT_CSV", "transactions",
                         f"{queryset.count()} rows exported from admin panel")
        return transactions_to_csv(queryset.select_related("user"))
