from drf_spectacular.utils import extend_schema
from rest_framework import generics, status
from rest_framework.response import Response

from .models import Card
from .serializers import AddCardSerializer, CardSerializer


class CardListCreateView(generics.ListCreateAPIView):
    def get_queryset(self):
        # users can only ever see their own cards
        return Card.objects.filter(user=self.request.user)

    def get_serializer_class(self):
        if self.request.method == "POST":
            return AddCardSerializer
        return CardSerializer

    @extend_schema(request=AddCardSerializer, responses={201: CardSerializer})
    def post(self, request, *args, **kwargs):
        serializer = AddCardSerializer(data=request.data, context={"request": request})
        serializer.is_valid(raise_exception=True)
        card = serializer.save()
        return Response(CardSerializer(card).data, status=status.HTTP_201_CREATED)


class CardDetailView(generics.RetrieveDestroyAPIView):
    serializer_class = CardSerializer

    def get_queryset(self):
        return Card.objects.filter(user=self.request.user)
