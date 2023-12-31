extends Node2D

var rng = RandomNumberGenerator.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	#init_new_game(0)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func init_new_game(seed):
	rng.set_seed(seed)
	var tilexyz_ary = get_new_game_tilexyz_ary()
	var tiletype_ary = cal_new_game_tiletype_ary(seed)
	#print(tilexyz_ary.size())
	#print(tiletype_ary.size())
	assert(tilexyz_ary.size() == tiletype_ary.size())
	var tile_ary_size = tilexyz_ary.size()
	for i in range(tile_ary_size):
		var tilexyz = tilexyz_ary[i]
		var tiletype = tiletype_ary[i]
		$TilesTransform/Tiles.create_tile(tilexyz, tiletype)
	#fix_tile_z_index()
	$TilesTransform/Tiles.fix_z_index()
	$TilesTransform/Tiles.check_status()
	$TilesTransform.store_bound_rect()
	$TilesTransform.fix_transform()

func get_new_game_tilexyz_ary():
	var z_y_x0_w_ary = [
		[0,0,1,12],
		[0,1,3,8],
		[0,2,2,10],
		[0,3,1,12],
		[0,4,1,12],
		[0,5,2,10],
		[0,6,3,8],
		[0,7,1,12],

		[0,3.5,0,1],
		[0,3.5,13,2],

		[1,1,4,6],
		[1,2,4,6],
		[1,3,4,6],
		[1,4,4,6],
		[1,5,4,6],
		[1,6,4,6],

		[2,2,5,4],
		[2,3,5,4],
		[2,4,5,4],
		[2,5,5,4],

		[3,3,6,2],
		[3,4,6,2],
		
		[4,3.5,6.5,1],
	]
	var ret_tilexyz_ary = Array()
	for z_y_x0_w in z_y_x0_w_ary:
		var z = z_y_x0_w[0]
		var y = z_y_x0_w[1]
		var x0 = z_y_x0_w[2]
		var w = z_y_x0_w[3]
		for i in range(w):
			var x = x0 + i
			ret_tilexyz_ary.append([x,y,z])
	return ret_tilexyz_ary
	

	for x in range(1, 13):
		ret_tilexyz_ary.append([x,0,0])

	for x in range(3, 11):
		ret_tilexyz_ary.append([x,1,0])
	for x in range(4, 10):
		ret_tilexyz_ary.append([x,1,1])

	for x in range(3, 11):
		ret_tilexyz_ary.append([x,1,0])
	for x in range(4, 10):
		ret_tilexyz_ary.append([x,1,1])
	
func cal_new_game_tiletype_ary(seed):
	var suit_value_count_ary = [
		[0, 9, 4],
		[1, 9, 4],
		[2, 9, 4],
		[3, 4, 4],
		[4, 3, 4],
		[5, 4, 1],
		[6, 4, 1]
	]
	
	var ret_tiletype_ary = Array()
	for suit_value_count in suit_value_count_ary:
		var suit = suit_value_count[0]
		var value = suit_value_count[1]
		var count = suit_value_count[2]
		for v in range(value):
			for c in range(count):
				ret_tiletype_ary.append([suit, v])
	
	ret_tiletype_ary = Common.shuffle(ret_tiletype_ary, rng)
	
	return ret_tiletype_ary

#func fix_tile_z_index():
	#var z_tile_node_ary=Array()
	#for tile_node in $TilesTransform/Tiles.get_children():
		#z_tile_node_ary.append([tile_node.z_ref, tile_node])
	#z_tile_node_ary.sort()
	#for i in range(z_tile_node_ary.size()):
		#z_tile_node_ary[i][1].z_index = i

signal status_no_pair(me)
func _on_tiles_status_no_pair(node):
	status_no_pair.emit(self)

func fix_no_pair():
	var all_tilenode_ary = get_tilenode_ary()
	var all_tilexyz_ary = Array()
	var all_tiletype_ary = Array()
	for tilenode in all_tilenode_ary:
		all_tilexyz_ary.append(tilenode.tilexyz)
		all_tiletype_ary.append(tilenode.tiletype)
	all_tilexyz_ary.sort()
	all_tiletype_ary.sort()

	var selectable_tilenode_ary = get_selectable_tilenode_ary()
	var selectable_tilexyz_ary = Array()
	for tilenode in selectable_tilenode_ary:
		selectable_tilexyz_ary.append(tilenode.tilexyz)
	selectable_tilexyz_ary.sort()

	assert(all_tilexyz_ary.size()>0)
	assert(all_tilexyz_ary.size()%2==0)
	assert(all_tiletype_ary.size()==all_tilexyz_ary.size())
	for i in range(0,all_tiletype_ary.size(),2):
		var tiletype0 = all_tiletype_ary[i]
		var tiletype1 = all_tiletype_ary[i+1]
		assert(Tile.remove_match(tiletype0, tiletype1))
	
	selectable_tilexyz_ary = Common.shuffle(selectable_tilexyz_ary, rng)
	var pair_tilexyz_ary = selectable_tilexyz_ary.slice(0,2)
	var unpair_tilexyz_ary = all_tilexyz_ary.duplicate(true)
	for tilexyz in pair_tilexyz_ary:
		unpair_tilexyz_ary.erase(tilexyz)
	unpair_tilexyz_ary = Common.shuffle(unpair_tilexyz_ary, rng)
	
	var t = rng.randi_range(0, (all_tiletype_ary.size()/2)-1)
	var pair_tiletype_ary = all_tiletype_ary.slice(t*2,t*2+2)
	var unpair_tiletype_ary = all_tiletype_ary.duplicate(true)
	for tiletype in pair_tiletype_ary:
		unpair_tiletype_ary.erase(tiletype)
	unpair_tiletype_ary.sort()
	
	kill_all_tiles()
	
	# verify
	var all_tilexyz0_ary = Array()
	all_tilexyz0_ary.append_array(pair_tilexyz_ary)
	all_tilexyz0_ary.append_array(unpair_tilexyz_ary)
	all_tilexyz0_ary.sort()
	print(all_tilexyz0_ary)
	print(all_tilexyz_ary)
	assert(all_tilexyz0_ary==all_tilexyz_ary)
	var all_tiletype0_ary = Array()
	all_tiletype0_ary.append_array(pair_tiletype_ary)
	all_tiletype0_ary.append_array(unpair_tiletype_ary)
	all_tiletype0_ary.sort()
	print(all_tiletype0_ary)
	print(all_tiletype_ary)
	assert(all_tiletype0_ary==all_tiletype_ary)
	
	
	var tilexyz_ary
	var tiletype_ary
	var tile_ary_size
	
	tilexyz_ary = pair_tilexyz_ary
	tiletype_ary = pair_tiletype_ary
	assert(tilexyz_ary.size() == tiletype_ary.size())
	tile_ary_size = tilexyz_ary.size()
	for i in range(tile_ary_size):
		var tilexyz = tilexyz_ary[i]
		var tiletype = tiletype_ary[i]
		$TilesTransform/Tiles.create_tile(tilexyz, tiletype)

	tilexyz_ary = unpair_tilexyz_ary
	tiletype_ary = unpair_tiletype_ary
	assert(tilexyz_ary.size() == tiletype_ary.size())
	tile_ary_size = tilexyz_ary.size()
	for i in range(tile_ary_size):
		var tilexyz = tilexyz_ary[i]
		var tiletype = tiletype_ary[i]
		$TilesTransform/Tiles.create_tile(tilexyz, tiletype)

	$TilesTransform/Tiles.fix_z_index()
	$TilesTransform/Tiles.check_status()
	#$TilesTransform.store_bound_rect()
	#$TilesTransform.fix_transform()

func show_tips():
	if $TilesTransform/Tiles.status != "PAIR_EXIST": return
	
	var selectable_tilenode_ary = get_selectable_tilenode_ary()
	var all_tilenode_ary = get_tilenode_ary()

	var tiletypex_to_tilenode_ary_dict = {}
	for tilenode in selectable_tilenode_ary:
		var tiletypex = tilenode.tiletype.duplicate(true)
		if tiletypex[0] >= 5: tiletypex[1] = -1
		if not tiletypex_to_tilenode_ary_dict.has(tiletypex):
			tiletypex_to_tilenode_ary_dict[tiletypex] = Array()
		tiletypex_to_tilenode_ary_dict[tiletypex].append(tilenode)
	var tiletypex_ary = tiletypex_to_tilenode_ary_dict.keys().duplicate(true)
	for tiletypex in tiletypex_ary:
		if tiletypex_to_tilenode_ary_dict[tiletypex].size() >= 2: continue
		tiletypex_to_tilenode_ary_dict.erase(tiletypex)
	assert(tiletypex_to_tilenode_ary_dict.size()>=1)
	tiletypex_ary = tiletypex_to_tilenode_ary_dict.keys().duplicate(true)
	var pair_tiletypex = tiletypex_ary[Common.rng.randi_range(0,tiletypex_ary.size()-1)]
	var tilenode_ary = tiletypex_to_tilenode_ary_dict[pair_tiletypex]
	tilenode_ary.shuffle()

	for tilenode in all_tilenode_ary:
		tilenode.set_tips_highlight(false)

	tilenode_ary[0].set_tips_highlight(true)
	tilenode_ary[1].set_tips_highlight(true)

func get_selectable_tilenode_ary():
	var all_tilenode_ary = get_tilenode_ary()
	
	var selectable_tilenode_ary = Array()
	for tilenode_i in all_tilenode_ary:
		if not $TilesTransform/Tiles.get_tile_selectable(tilenode_i): continue
		selectable_tilenode_ary.append(tilenode_i)
	
	return selectable_tilenode_ary

func get_tilenode_ary():
	return $TilesTransform/Tiles.get_children()

func kill_all_tiles():
	for node in $TilesTransform/Tiles.get_children():
		$TilesTransform/Tiles.remove_child(node)
		node.queue_free()
