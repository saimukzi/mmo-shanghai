@tool
extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	update()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	update()

const ZERO = Vector2.ZERO

func update():
	if position != ZERO:
		position = ZERO
