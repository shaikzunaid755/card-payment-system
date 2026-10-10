from datetime import date

from rest_framework import serializers

from .models import Card
from .utils import detect_brand, luhn_valid, mask_number


class CardSerializer(serializers.ModelSerializer):
    """Used to show cards. Only safe fields are here."""

    class Meta:
        model = Card
        fields = ["id", "cardholder_name", "card_type", "brand", "masked_number",
                  "last4", "expiry_month", "expiry_year", "created_at"]
        read_only_fields = fields


class AddCardSerializer(serializers.Serializer):
    """Used only when adding a card. card_number and cvv are checked and then thrown away."""

    cardholder_name = serializers.CharField(max_length=100)
    card_type = serializers.ChoiceField(choices=Card.CardType.choices)
    card_number = serializers.CharField(write_only=True)
    cvv = serializers.CharField(write_only=True)
    expiry_month = serializers.IntegerField(min_value=1, max_value=12)
    expiry_year = serializers.IntegerField()

    def validate_card_number(self, value):
        number = value.replace(" ", "").replace("-", "")
        if not number.isdigit() or not 13 <= len(number) <= 19:
            raise serializers.ValidationError("Card number must be 13 to 19 digits.")
        if not luhn_valid(number):
            raise serializers.ValidationError("Card number is not valid.")
        return number

    def validate_cvv(self, value):
        if not value.isdigit() or len(value) not in (3, 4):
            raise serializers.ValidationError("CVV must be 3 or 4 digits.")
        return value

    def validate_cardholder_name(self, value):
        if not value.replace(" ", "").replace(".", "").isalpha():
            raise serializers.ValidationError("Name can only contain letters and spaces.")
        return value.strip()

    def validate(self, data):
        today = date.today()
        year, month = data["expiry_year"], data["expiry_month"]
        if (year, month) < (today.year, today.month):
            raise serializers.ValidationError({"expiry_year": "This card has expired."})
        if year > today.year + 20:
            raise serializers.ValidationError({"expiry_year": "Expiry year is too far away."})
        return data

    def create(self, validated_data):
        number = validated_data["card_number"]
        # the CVV is never used after validation, so it is never saved anywhere
        return Card.objects.create(
            user=self.context["request"].user,
            cardholder_name=validated_data["cardholder_name"],
            card_type=validated_data["card_type"],
            brand=detect_brand(number),
            masked_number=mask_number(number),
            last4=number[-4:],
            expiry_month=validated_data["expiry_month"],
            expiry_year=validated_data["expiry_year"],
        )
