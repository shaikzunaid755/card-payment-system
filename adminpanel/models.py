from django.conf import settings
from django.db import models

from transactions.models import Transaction


class AdminLog(models.Model):
    # keeps a record of what admins did (edits, deletes, CSV exports)
    admin = models.ForeignKey(settings.AUTH_USER_MODEL, null=True, blank=True,
                              on_delete=models.SET_NULL, related_name="admin_logs")
    action = models.CharField(max_length=50)
    target = models.CharField(max_length=100, blank=True)
    details = models.TextField(blank=True)
    ip_address = models.GenericIPAddressField(null=True, blank=True)
    created_at = models.DateTimeField(auto_now_add=True)

    class Meta:
        db_table = "admin_logs"
        ordering = ["-created_at"]

    def __str__(self):
        return f"{self.action} by {self.admin} at {self.created_at:%Y-%m-%d %H:%M}"


class DailySummary(Transaction):
    # proxy model = no new table. It only exists so we get a
    # "Daily payment summary" page inside the Django admin.
    class Meta:
        proxy = True
        verbose_name = "Daily payment summary"
        verbose_name_plural = "Daily payment summary"
