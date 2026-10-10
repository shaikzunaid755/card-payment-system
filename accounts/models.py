from django.contrib.auth.models import AbstractUser
from django.db import models


class User(AbstractUser):
    # Django's default user already has username, password (hashed), first_name,
    # last_name, is_staff, is_active... we just make email required and unique
    email = models.EmailField(unique=True)
    phone = models.CharField(max_length=15, blank=True)

    class Meta:
        db_table = "users"

    def __str__(self):
        return self.username
