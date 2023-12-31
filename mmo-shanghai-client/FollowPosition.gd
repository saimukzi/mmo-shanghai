@tool
extends Node2D

@export var node : Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	update()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	update()


func update():
	if node == null: return
	var new_position = node.position
	if position != new_position:
		position = new_position
