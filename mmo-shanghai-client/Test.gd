extends Control

#var _client = WebSocketClient.new()
var _websocket : WebSocketPeer = null

var _cooldown = 100

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if self._websocket != null:
		self._websocket.poll()
		var state = self._websocket.get_ready_state()
		print('state = {0}'.format([state]))
	pass


func _on_connect_pressed():
	print('_on_connect_pressed')
	if self._websocket != null:
		self._websocket.close()
		self._websocket = null
	self._websocket = WebSocketPeer.new()
	var err = self._websocket.connect_to_url(
		'ws://127.0.0.1:8000/ws/mjslt/asdf/'
	)
	#var err = self._websocket.connect_to_url('wss://socketsbay.com/wss/v2/1/demo/')
	print('connect_to_url ret = {0}'.format([err]))
	pass # Replace with function body.


func _on_msg_pressed():
	print('_on_msg_pressed')
	if self._websocket != null:
		#var err = self._websocket.send_text('{"type":"message","message":"asdf"}\n')
		var err = self._websocket.send_text('{"type":"message","message":"asdf"}')
		print('connect_to_url ret = {0}'.format([err]))
	pass # Replace with function body.


func _on_disconnect_pressed():
	print('_on_disconnect_pressed')
	if self._websocket != null:
		self._websocket.close()
		self._websocket = null
	pass # Replace with function body.
