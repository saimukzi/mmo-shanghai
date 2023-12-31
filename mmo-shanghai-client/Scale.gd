@tool
extends Node2D


@export var node0 : Node2D
@export var node1 : Node2D
@export var inner_value : float = 256


# Called when the node enters the scene tree for the first time.
func _ready():
	update()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	update()
	

func update():
	if node0 == null: return
	if node1 == null: return
	var outer_value = node0.position.distance_to(node1.position)
	var target_scale = (outer_value / inner_value) * Vector2.ONE
	if scale != target_scale:
		scale = target_scale
	
