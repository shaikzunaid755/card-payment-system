import uuid
from datetime import datetime, timezone

from fastapi import Depends, FastAPI, HTTPException, status
from sqlalchemy.orm import Session

from payment_service import simulator
from payment_service.auth import get_current_user
from payment_service.database import get_db
from payment_service.models import CardRow, TransactionRow, UserRow
from payment_service.schemas import PaymentRequest, PaymentResponse

app = FastAPI(
    title="Credit Card Payment System - Payment Service",
    description="Makes simulated payments. Log in with the Django API first and "
                "use the access token here (click Authorize).",
    version="1.0.0",
)


def utc_now():
    # MySQL DATETIME has no timezone, so we store UTC without tzinfo
    return datetime.now(timezone.utc).replace(tzinfo=None)


@app.get("/health", tags=["Health"])
def health():
    return {"status": "ok"}


@app.post("/payments/", response_model=PaymentResponse, status_code=status.HTTP_201_CREATED,
          tags=["Payments"])
def make_payment(
    payment: PaymentRequest,
    db: Session = Depends(get_db),
    user: UserRow = Depends(get_current_user),
):
    # the card must exist AND belong to the logged in user
    card = db.query(CardRow).filter(CardRow.id == payment.card_id,
                                    CardRow.user_id == user.id).first()
    if card is None:
        raise HTTPException(status_code=404, detail="Card not found")

    now = utc_now()
    if (card.expiry_year, card.expiry_month) < (now.year, now.month):
        raise HTTPException(status_code=400, detail="Card has expired")

    # step 1: save the payment as PENDING
    transaction = TransactionRow(
        reference=str(uuid.uuid4()),
        user_id=user.id,
        card_id=card.id,
        card_last4=card.last4,
        amount=payment.amount,
        currency=payment.currency.upper(),
        description=payment.description,
        status="PENDING",
        failure_reason="",
        created_at=now,
        updated_at=now,
    )
    db.add(transaction)
    db.commit()
    db.refresh(transaction)

    # step 2: pretend to contact the bank, then save the final status
    success, reason = simulator.simulate_payment()
    transaction.status = "SUCCESS" if success else "FAILED"
    transaction.failure_reason = reason
    transaction.updated_at = utc_now()
    db.commit()
    db.refresh(transaction)

    return transaction


@app.get("/payments/{reference}", response_model=PaymentResponse, tags=["Payments"])
def get_payment(
    reference: str,
    db: Session = Depends(get_db),
    user: UserRow = Depends(get_current_user),
):
    transaction = db.query(TransactionRow).filter(TransactionRow.reference == reference,
                                                  TransactionRow.user_id == user.id).first()
    if transaction is None:
        raise HTTPException(status_code=404, detail="Payment not found")
    return transaction
