import csv

from django.http import HttpResponse


def safe_cell(value):
    # stops "CSV injection": Excel treats cells starting with these as formulas
    text = str(value)
    if text and text[0] in ("=", "+", "-", "@"):
        return "'" + text
    return text


def transactions_to_csv(queryset, filename="transactions.csv"):
    response = HttpResponse(content_type="text/csv")
    response["Content-Disposition"] = f'attachment; filename="{filename}"'

    writer = csv.writer(response)
    writer.writerow(["Reference", "User", "Card", "Amount", "Currency",
                     "Status", "Failure reason", "Description", "Created at"])
    for t in queryset:
        writer.writerow([
            t.reference,
            safe_cell(t.user.username),
            f"**** {t.card_last4}",
            t.amount,
            t.currency,
            t.status,
            safe_cell(t.failure_reason),
            safe_cell(t.description),
            t.created_at.strftime("%Y-%m-%d %H:%M:%S"),
        ])
    return response
