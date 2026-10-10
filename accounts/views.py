from drf_spectacular.utils import extend_schema
from rest_framework import generics, status
from rest_framework.permissions import AllowAny
from rest_framework.response import Response
from rest_framework.views import APIView
from rest_framework_simplejwt.exceptions import TokenError
from rest_framework_simplejwt.tokens import RefreshToken

from .serializers import LogoutSerializer, RegisterSerializer, UserSerializer


class RegisterView(generics.CreateAPIView):
    serializer_class = RegisterSerializer
    permission_classes = [AllowAny]


class LogoutView(APIView):
    @extend_schema(request=LogoutSerializer, responses={200: None})
    def post(self, request):
        serializer = LogoutSerializer(data=request.data)
        serializer.is_valid(raise_exception=True)

        # blacklisting the refresh token means it can't be used again
        try:
            token = RefreshToken(serializer.validated_data["refresh"])
            token.blacklist()
        except TokenError:
            return Response({"detail": "Invalid or expired token."},
                            status=status.HTTP_400_BAD_REQUEST)

        return Response({"detail": "Logged out successfully."})


class MeView(generics.RetrieveAPIView):
    # a simple protected route: returns the logged in user's profile
    serializer_class = UserSerializer

    def get_object(self):
        return self.request.user
