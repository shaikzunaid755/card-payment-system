from .models import AdminLog


def log_admin_action(request, action, target="", details=""):
    AdminLog.objects.create(
        admin=request.user if request.user.is_authenticated else None,
        action=action,
        target=target,
        details=details,
        ip_address=request.META.get("REMOTE_ADDR"),
    )
