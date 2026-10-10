def luhn_valid(number):
    """Standard Luhn check that real card numbers pass."""
    total = 0
    # go from right to left and double every second digit
    for position, char in enumerate(reversed(number)):
        digit = int(char)
        if position % 2 == 1:
            digit *= 2
            if digit > 9:
                digit -= 9
        total += digit
    return total % 10 == 0


def detect_brand(number):
    if number.startswith("4"):
        return "Visa"
    if number[:2] in ("51", "52", "53", "54", "55") or 2221 <= int(number[:4]) <= 2720:
        return "Mastercard"
    if number[:2] in ("34", "37"):
        return "Amex"
    if number.startswith("6011") or number[:2] == "65":
        return "Discover"
    if number[:2] in ("60", "81", "82"):
        return "RuPay"
    return "Unknown"


def mask_number(number):
    return "**** **** **** " + number[-4:]
