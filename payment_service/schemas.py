from datetime import datetime
from decimal import Decimal

from pydantic import BaseModel, ConfigDict, Field


class PaymentRequest(BaseModel):
    card_id: int = Field(gt=0, description="ID of a card saved in the Django API")
    amount: Decimal = Field(gt=0, le=1000000, decimal_places=2, examples=["499.00"])
    currency: str = Field(default="INR", pattern="^[A-Za-z]{3}$")
    description: str = Field(default="", max_length=255)


class PaymentResponse(BaseModel):
    model_config = ConfigDict(from_attributes=True)

    reference: str
    card_id: int | None
    card_last4: str
    amount: Decimal
    currency: str
    description: str
    status: str
    failure_reason: str
    created_at: datetime
    updated_at: datetime
