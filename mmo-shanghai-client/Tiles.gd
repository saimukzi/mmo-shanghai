extends Node2D

var mouse_done = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _input(event):
	if     event.get_class() == "InputEventMouseButton" \
	   and event.button_index == MouseButton.MOUSE_BUTTON_LEFT \
	   and not event.pressed:
		print('asdf')
		mouse_done = false

var tile_scene = preload("res://Tile.tscn")
func create_tile(tilexyz, tiletype):
	var tile = tile_scene.instantiate()
	tile.set_tilebase(0)
	tile.set_tiletype(tiletype)
	tile.set_tilexyz(tilexyz)
	tile.connect("mouse_entered", self._on_tile_mouse_entered)
	tile.connect("mouse_exited", self._on_tile_mouse_exited)
	tile.connect("mouse_pressed", self._on_tile_mouse_pressed)
	add_child(tile)

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
	
var z_to_tilenode_dict
func fix_z_index():
	z_to_tilenode_dict = {}
	var z_tile_node_ary=Array()
	for tile_node in get_children():
		z_tile_node_ary.append([tile_node.z_ref, tile_node])
	z_tile_node_ary.sort()
	for i in range(z_tile_node_ary.size()):
		var tile_node = z_tile_node_ary[i][1]
		tile_node.z_index = i + tile_node.tilexyz[2]*500
		tile_node.z_val = i
		z_to_tilenode_dict[i] = tile_node

var mouseover_z_ary = Array()

func last_mouseover_z():
	if mouseover_z_ary.is_empty():
		return -1
	return mouseover_z_ary[-1]

func _on_tile_mouse_entered(tilenode):
	var oldZ = last_mouseover_z()
	if mouseover_z_ary.find(tilenode.z_val) == -1:
		mouseover_z_ary.append(tilenode.z_val)
	mouseover_z_ary.sort()
	var newZ = last_mouseover_z()
	if newZ != oldZ:
		if oldZ != -1:
			z_to_tilenode_dict[oldZ].set_highlight(false)
		if newZ != -1:
			var new_tile = z_to_tilenode_dict[newZ]
			new_tile.set_highlight(get_tile_selectable(new_tile))

func _on_tile_mouse_exited(tilenode):
	var oldZ = last_mouseover_z()
	mouseover_z_ary.erase(tilenode.z_val)
	mouseover_z_ary.sort()
	var newZ = last_mouseover_z()
	if newZ != oldZ:
		if oldZ != -1:
			z_to_tilenode_dict[oldZ].set_highlight(false)
		if newZ != -1:
			var new_tile = z_to_tilenode_dict[newZ]
			new_tile.set_highlight(get_tile_selectable(new_tile))

var selected_tile = null
func _on_tile_mouse_pressed(tilenode):
	if mouse_done: return
	if tilenode == selected_tile:
		tilenode.set_selected(false)
		selected_tile = null
		mouse_done = true
		return
	if not get_tile_selectable(tilenode): return
	if tilenode.z_val != last_mouseover_z(): return
	if selected_tile == null:
		tilenode.set_selected(true)
		selected_tile = tilenode
		mouse_done = true
		return
	if Tile.remove_match(selected_tile.tiletype, tilenode.tiletype):
	#if selected_tile.tiletype == tilenode.tiletype:
		remove_tile(selected_tile)
		remove_tile(tilenode)
		selected_tile = null
		mouse_done = true
		return
	selected_tile.set_selected(false)
	tilenode.set_selected(true)
	selected_tile = tilenode
	mouse_done = true

func get_tile_selectable(tilenode):
	var exist_left = false
	var exist_right = false
	for tilenode_i in get_children():
		if tilenode_i == tilenode: continue
		if tilenode.get_close_top(tilenode_i): return false
		exist_left = exist_left or tilenode.get_close_left(tilenode_i)
		exist_right = exist_right or tilenode.get_close_right(tilenode_i)
		if exist_left && exist_right: return false
	return true

func remove_tile(tilenode):
	mouseover_z_ary.erase(tilenode.z_val)
	z_to_tilenode_dict.erase(tilenode.z_val)
	remove_child(tilenode)
