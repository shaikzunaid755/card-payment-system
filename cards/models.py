from django.conf import settings
from django.db import models


class Card(models.Model):
    class CardType(models.TextChoices):
        CREDIT = "CREDIT", "Credit"
        DEBIT = "DEBIT", "Debit"

    user = models.ForeignKey(settings.AUTH_USER_MODEL, on_delete=models.CASCADE,
                             related_name="cards")
    cardholder_name = models.CharField(max_length=100)
    card_type = models.CharField(max_length=10, choices=CardType.choices)
    brand = models.CharField(max_length=20, default="Unknown")

    # We NEVER save the real card number or the CVV.
    # Only the masked number and the last 4 digits are stored.
    masked_number = models.CharField(max_length=25)
    last4 = models.CharField(max_length=4)

    expiry_month = models.PositiveSmallIntegerField()
    expiry_year = models.PositiveSmallIntegerField()
    created_at = models.DateTimeField(auto_now_add=True)

    class Meta:
        db_table = "cards"
        ordering = ["-created_at"]

    def __str__(self):
        return f"{self.brand} {self.masked_number}"
