from .utils import log_admin_action


class LogActionsMixin:
    """Add this to a ModelAdmin to write every create / update / delete into admin_logs."""

    def save_model(self, request, obj, form, change):
        super().save_model(request, obj, form, change)
        action = "UPDATE" if change else "CREATE"
        log_admin_action(request, action, f"{obj._meta.model_name}:{obj.pk}")

    def delete_model(self, request, obj):
        target = f"{obj._meta.model_name}:{obj.pk}"
        super().delete_model(request, obj)
        log_admin_action(request, "DELETE", target)

    def delete_queryset(self, request, queryset):
        target = f"{queryset.model._meta.model_name}: {queryset.count()} rows"
        super().delete_queryset(request, queryset)
        log_admin_action(request, "BULK_DELETE", target)
