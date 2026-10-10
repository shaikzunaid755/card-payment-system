from sqlalchemy import Boolean, Column, DateTime, ForeignKey, Integer, Numeric, String

from payment_service.database import Base

# These classes map to tables that DJANGO creates (users, cards, transactions).
# We never create tables here, we only read and write rows.
# Only the columns this service needs are listed.


class UserRow(Base):
    __tablename__ = "users"

    id = Column(Integer, primary_key=True)
    username = Column(String(150))
    is_active = Column(Boolean)


class CardRow(Base):
    __tablename__ = "cards"

    id = Column(Integer, primary_key=True)
    user_id = Column(Integer, ForeignKey("users.id"))
    last4 = Column(String(4))
    expiry_month = Column(Integer)
    expiry_year = Column(Integer)


class TransactionRow(Base):
    __tablename__ = "transactions"

    id = Column(Integer, primary_key=True)
    reference = Column(String(36), unique=True)
    user_id = Column(Integer, ForeignKey("users.id"))
    card_id = Column(Integer, ForeignKey("cards.id"), nullable=True)
    card_last4 = Column(String(4))
    amount = Column(Numeric(12, 2))
    currency = Column(String(3))
    description = Column(String(255))
    status = Column(String(10))
    failure_reason = Column(String(255))
    created_at = Column(DateTime)
    updated_at = Column(DateTime)
