extends Control

#var active = false
#var start_tick = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	#_dialog().visible = false
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

#func _input(event):
	#if not active: return
	#if Time.get_ticks_msec() < start_tick + 500: return
	#if     event.get_class() == "InputEventMouseButton" \
	   #and event.button_index == MouseButton.MOUSE_BUTTON_LEFT \
	   #and not event.pressed:
		#owner.board_node.fix_no_pair()
		##_dialog().visible = false
		#active = false

func start():
	#active = true
	self.visible = true
	await get_tree().create_timer(0.5).timeout
	await $Click.pressed
	self.visible = false
	#_dialog().visible = true

func _on_board_status_no_pair(board_node):
	start()
#
#func _dialog():
	#return $Visible
