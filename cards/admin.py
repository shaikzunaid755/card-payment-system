from django.contrib import admin

from adminpanel.mixins import LogActionsMixin

from .models import Card


@admin.register(Card)
class CardAdmin(LogActionsMixin, admin.ModelAdmin):
    list_display = ["id", "user", "brand", "masked_number", "card_type",
                    "expiry_month", "expiry_year", "created_at"]
    list_filter = ["card_type", "brand"]
    search_fields = ["user__username", "user__email", "last4", "cardholder_name"]

    # admins can look at cards (and delete them) but never create or edit them
    def has_add_permission(self, request):
        return False

    def has_change_permission(self, request, obj=None):
        return False
