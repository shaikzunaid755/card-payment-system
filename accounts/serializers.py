from django.contrib.auth.password_validation import validate_password
from rest_framework import serializers

from .models import User


class RegisterSerializer(serializers.ModelSerializer):
    password = serializers.CharField(write_only=True)
    confirm_password = serializers.CharField(write_only=True)

    class Meta:
        model = User
        fields = ["id", "username", "email", "first_name", "last_name", "phone",
                  "password", "confirm_password"]

    def validate_email(self, value):
        value = value.lower()
        if User.objects.filter(email__iexact=value).exists():
            raise serializers.ValidationError("A user with this email already exists.")
        return value

    def validate_phone(self, value):
        if value and (not value.isdigit() or not 10 <= len(value) <= 15):
            raise serializers.ValidationError("Phone number must be 10 to 15 digits.")
        return value

    def validate(self, data):
        if data["password"] != data["confirm_password"]:
            raise serializers.ValidationError({"confirm_password": "Passwords do not match."})
        # runs Django's password rules (length, too common, only numbers...)
        temp_user = User(username=data.get("username"), email=data.get("email"))
        validate_password(data["password"], temp_user)
        return data

    def create(self, validated_data):
        validated_data.pop("confirm_password")
        # create_user hashes the password for us
        return User.objects.create_user(**validated_data)


class UserSerializer(serializers.ModelSerializer):
    class Meta:
        model = User
        fields = ["id", "username", "email", "first_name", "last_name", "phone", "date_joined"]
        read_only_fields = fields


class LogoutSerializer(serializers.Serializer):
    refresh = serializers.CharField()
