from django.contrib import admin
from django.contrib.auth.admin import UserAdmin as BaseUserAdmin

from adminpanel.mixins import LogActionsMixin

from .models import User


@admin.register(User)
class UserAdmin(LogActionsMixin, BaseUserAdmin):
    list_display = ["username", "email", "first_name", "last_name", "is_staff",
                    "is_active", "date_joined"]
    list_filter = ["is_staff", "is_active", "date_joined"]
    search_fields = ["username", "email", "first_name", "last_name"]

    # add the extra fields to the normal Django user forms
    fieldsets = BaseUserAdmin.fieldsets + (("Extra info", {"fields": ("phone",)}),)
    add_fieldsets = BaseUserAdmin.add_fieldsets + (
        ("Extra info", {"fields": ("email", "phone")}),
    )
