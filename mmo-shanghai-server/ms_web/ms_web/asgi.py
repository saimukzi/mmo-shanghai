import os

from channels.auth import AuthMiddlewareStack
from channels.routing import ProtocolTypeRouter, URLRouter
from channels.security.websocket import AllowedHostsOriginValidator
from django.core.asgi import get_asgi_application

os.environ.setdefault("DJANGO_SETTINGS_MODULE", "ms_web.settings")
# Initialize Django ASGI application early to ensure the AppRegistry
# is populated before importing code that may import ORM models.
django_asgi_app = get_asgi_application()

import chat.routing
import mjslt.routing

# application = ProtocolTypeRouter(
#     {
#         "http": django_asgi_app,
#         "websocket": AllowedHostsOriginValidator(
#             AuthMiddlewareStack(URLRouter(
#                 chat.routing.websocket_urlpatterns +
#                 mjslt.routing.websocket_urlpatterns
#             ))
#         ),
#     }
# )

application = ProtocolTypeRouter(
    {
        "http": django_asgi_app,
        "websocket": 
            AuthMiddlewareStack(URLRouter(
                chat.routing.websocket_urlpatterns +
                mjslt.routing.websocket_urlpatterns
            ))
        ,
    }
)
