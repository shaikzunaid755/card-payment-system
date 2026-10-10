from django.contrib import admin
from django.template.response import TemplateResponse

from .models import AdminLog, DailySummary
from .summary import get_daily_summary


@admin.register(AdminLog)
class AdminLogAdmin(admin.ModelAdmin):
    list_display = ["created_at", "admin", "action", "target", "ip_address"]
    list_filter = ["action", "created_at"]
    search_fields = ["admin__username", "target", "details"]

    # logs are read only, nobody should be able to change history
    def has_add_permission(self, request):
        return False

    def has_change_permission(self, request, obj=None):
        return False

    def has_delete_permission(self, request, obj=None):
        return False


@admin.register(DailySummary)
class DailySummaryAdmin(admin.ModelAdmin):
    change_list_template = "adminpanel/daily_summary.html"

    def has_add_permission(self, request):
        return False

    def has_change_permission(self, request, obj=None):
        return False

    def has_delete_permission(self, request, obj=None):
        return False

    def changelist_view(self, request, extra_context=None):
        context = {
            **self.admin_site.each_context(request),
            "title": "Daily payment summary",
            "opts": self.model._meta,
            "rows": get_daily_summary(),
        }
        return TemplateResponse(request, self.change_list_template, context)
