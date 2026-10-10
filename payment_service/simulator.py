import random

from payment_service.config import PAYMENT_SUCCESS_RATE

FAILURE_REASONS = [
    "Insufficient funds",
    "Card declined by the bank",
    "Payment gateway timeout",
    "Suspected fraud, payment blocked",
]


def simulate_payment():
    """Pretends to talk to a bank. Returns (success, failure_reason)."""
    if random.random() < PAYMENT_SUCCESS_RATE:
        return True, ""
    return False, random.choice(FAILURE_REASONS)
