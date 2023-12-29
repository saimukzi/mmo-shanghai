extends Node2D

var rng = RandomNumberGenerator.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func init_new_game(seed):
	rng.set_seed(seed)
	var tilexyz_ary = get_new_game_tilexyz_ary()
	var tiletype_ary = cal_new_game_tiletype_ary(seed)
	assert(tilexyz_ary.size() == tiletype_ary.size())
	var tile_ary_size = tilexyz_ary.size()
	for i in range(tile_ary_size):
		var tilexyz = tilexyz_ary[i]
		var tiletype = tiletype_ary[i]
		create_tile(tilexyz, tiletype)

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

		[1,1,4,8],
		[1,2,4,8],
		[1,3,4,8],
		[1,4,4,8],
		[1,5,4,8],
		[1,6,4,8],

		[2,2,5,6],
		[2,3,5,6],
		[2,4,5,6],
		[2,5,5,6],

		[3,3,6,4],
		[3,4,6,4],
		
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
			ret_tilexyz_ary.push([x,y,z])
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

var tile_scene = preload("res://Tile.tscn")

func create_tile(tilexyz, tiletype):
	var tile = tile_scene.instantiate()
	tile.set_tilexyz(tilexyz)
	tile.set_tiletype(tiletype)
	$Tiles.add_child(tile)

