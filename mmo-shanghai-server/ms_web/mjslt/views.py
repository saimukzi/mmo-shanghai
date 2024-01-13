# mjslt/views.py
from django.shortcuts import render


def index(request):
    return render(request, "mjslt/index.html")

def room(request, room_name):
    return render(request, "mjslt/room.html", {"room_name": room_name})
