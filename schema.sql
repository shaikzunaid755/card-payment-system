-- Database schema for the Credit Card Payment System (MySQL 8)
--
-- You do NOT need to run this file normally. Django creates these tables
-- when you run:  python manage.py migrate
-- This file is only here so the schema can be read / reviewed easily.

CREATE DATABASE IF NOT EXISTS card_payment_db CHARACTER SET utf8mb4;
USE card_payment_db;

-- 1. USERS (passwords are stored hashed, never as plain text)
CREATE TABLE users (
    id            BIGINT       NOT NULL AUTO_INCREMENT PRIMARY KEY,
    password      VARCHAR(128) NOT NULL,          -- pbkdf2_sha256 hash
    last_login    DATETIME(6)  NULL,
    is_superuser  TINYINT(1)   NOT NULL,
    username      VARCHAR(150) NOT NULL UNIQUE,
    first_name    VARCHAR(150) NOT NULL,
    last_name     VARCHAR(150) NOT NULL,
    is_staff      TINYINT(1)   NOT NULL,
    is_active     TINYINT(1)   NOT NULL,
    date_joined   DATETIME(6)  NOT NULL,
    email         VARCHAR(254) NOT NULL UNIQUE,
    phone         VARCHAR(15)  NOT NULL
) ENGINE=InnoDB;

-- 2. CARDS (no full card number and no CVV, only masked number + last 4 digits)
CREATE TABLE cards (
    id              BIGINT      NOT NULL AUTO_INCREMENT PRIMARY KEY,
    user_id         BIGINT      NOT NULL,
    cardholder_name VARCHAR(100) NOT NULL,
    card_type       VARCHAR(10) NOT NULL,         -- CREDIT / DEBIT
    brand           VARCHAR(20) NOT NULL,         -- Visa, Mastercard...
    masked_number   VARCHAR(25) NOT NULL,         -- **** **** **** 1111
    last4           VARCHAR(4)  NOT NULL,
    expiry_month    SMALLINT UNSIGNED NOT NULL,
    expiry_year     SMALLINT UNSIGNED NOT NULL,
    created_at      DATETIME(6) NOT NULL,
    FOREIGN KEY (user_id) REFERENCES users (id)
) ENGINE=InnoDB;

-- 3. TRANSACTIONS (created and updated by the FastAPI payment service)
CREATE TABLE transactions (
    id             BIGINT        NOT NULL AUTO_INCREMENT PRIMARY KEY,
    reference      VARCHAR(36)   NOT NULL UNIQUE,
    user_id        BIGINT        NOT NULL,
    card_id        BIGINT        NULL,            -- stays NULL if the card is deleted later
    card_last4     VARCHAR(4)    NOT NULL,
    amount         DECIMAL(12,2) NOT NULL,
    currency       VARCHAR(3)    NOT NULL,
    description    VARCHAR(255)  NOT NULL,
    status         VARCHAR(10)   NOT NULL,        -- PENDING / SUCCESS / FAILED
    failure_reason VARCHAR(255)  NOT NULL,
    created_at     DATETIME(6)   NOT NULL,
    updated_at     DATETIME(6)   NOT NULL,
    INDEX (status),
    INDEX (created_at),
    FOREIGN KEY (user_id) REFERENCES users (id),
    FOREIGN KEY (card_id) REFERENCES cards (id)
) ENGINE=InnoDB;

-- 4. ADMIN LOGS (what admins did: edits, deletes, CSV exports)
CREATE TABLE admin_logs (
    id         BIGINT       NOT NULL AUTO_INCREMENT PRIMARY KEY,
    admin_id   BIGINT       NULL,
    action     VARCHAR(50)  NOT NULL,
    target     VARCHAR(100) NOT NULL,
    details    LONGTEXT     NOT NULL,
    ip_address CHAR(39)     NULL,
    created_at DATETIME(6)  NOT NULL,
    FOREIGN KEY (admin_id) REFERENCES users (id)
) ENGINE=InnoDB;
