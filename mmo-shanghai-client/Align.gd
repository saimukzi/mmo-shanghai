@tool
extends Node2D

@export var align_x : float = 0.5
@export var align_y : float = 0.5

@export var node0 : Node2D
@export var node1 : Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	update()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	update()

func update():
	if node0 == null: return
	if node1 == null: return
	var node0_position = node0.position
	var node1_position = node1.position
	var new_x = node0_position.x*(1-align_x)+node1_position.x * align_x
	var new_y = node0_position.y*(1-align_y)+node1_position.y * align_y
	var new_position = Vector2(new_x, new_y)
	if position != new_position:
		position = new_position
