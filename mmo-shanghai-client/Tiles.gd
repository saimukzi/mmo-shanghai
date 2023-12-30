extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func get_bound_rect():
	var x0 = INF
	var x1 = -INF
	var y0 = INF
	var y1 = -INF
	for tile_node in get_children():
		var tile = tile_node as Tile
		var tile_pos = tile_node.position
		var tile_pos0 = tile_pos + Tile.POS0
		var tile_pos1 = tile_pos + Tile.POS1
		x0 = min(x0, tile_pos0.x)
		x1 = max(x1, tile_pos1.x)
		y0 = min(y0, tile_pos0.y)
		y1 = max(y1, tile_pos1.y)
	return [
		Vector2(x0, y0),
		Vector2(x1, y1)
	]

func fix_z_index():
	var z_tile_node_ary=Array()
	for tile_node in get_children():
		z_tile_node_ary.append([tile_node.z_ref, tile_node])
	z_tile_node_ary.sort()
	for i in range(z_tile_node_ary.size()):
		z_tile_node_ary[i][1].z_index = i
