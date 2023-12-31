@tool
extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	update()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	update()


func update():
	var new_position
	if Engine.is_editor_hint():
		new_position = Vector2(
			ProjectSettings.get_setting("display/window/size/viewport_width"),
			ProjectSettings.get_setting("display/window/size/viewport_height")
		)
	else:
		new_position = Vector2(get_viewport().size)
	if position != new_position:
		position = new_position
