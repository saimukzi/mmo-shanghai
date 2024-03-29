# mjslt/consumers.py
import json

from channels.generic.websocket import AsyncWebsocketConsumer


class MjsltConsumer(AsyncWebsocketConsumer):
    async def connect(self):
        self.room_name = self.scope["url_route"]["kwargs"]["room_name"]
        self.room_group_name = f"mjslt_{self.room_name}"

        # Join room group
        await self.channel_layer.group_add(self.room_group_name, self.channel_name)

        await self.accept()

    async def disconnect(self, close_code):
        # Leave room group
        await self.channel_layer.group_discard(self.room_group_name, self.channel_name)

    # Receive message from WebSocket
    async def receive(self, text_data):
        text_data_json = json.loads(text_data)

        if 'type' not in text_data_json:
            return

        # Send message to room group
        if text_data_json["type"] == "message":
            message = text_data_json["message"]
            await self.channel_layer.group_send(
                self.room_group_name, {"type": "mjslt.message", "message": message}
            )
        
        if text_data_json["type"] == "mjslt":
            print('mjslt')

    # Receive message from room group
    async def mjslt_message(self, event):
        message = event["message"]

        # Send message to WebSocket
        await self.send(text_data=json.dumps({"message": message}))
