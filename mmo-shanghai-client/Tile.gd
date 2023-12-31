extends Node2D

#var texture0 = preload("res://import/demching-mahjong/dot/02.svg")
#var texture0 = null

static var tiletypestr_to_texture_dict = {}

# Called when the node enters the scene tree for the first time.
func _ready():
	#texture0 = load("res://import/demching-mahjong/dot/02.svg")
	set_tiletype([0,7])
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func set_tiletype(tiletype):
	$Face.texture = get_texture(tiletype)

static func get_texture(tiletype):
	var tiletypestr = "{0}-{1}".format(tiletype)
	if not tiletypestr_to_texture_dict.has(tiletypestr):
		var p0 = ""
		var p1 = ""
		var suit = tiletype[0]
		var value = tiletype[1]
		if suit == 0:
			p0 = "dot"
			p1 = "%02d"%(value+1)
		elif suit == 1:
			p0 = "bamboo"
			p1 = "%02d"%(value+1)
		elif suit == 2:
			p0 = "character"
			p1 = "%02d"%(value+1)
		elif suit == 3:
			p0 = "wind"
			p1 = "%02d"%(value+1)
		elif suit == 4:
			p0 = "dragon"
			p1 = "%02d"%(value+1)
		elif suit == 5:
			p0 = "flower"
			p1 = "%02d"%(value+1)
		elif suit == 6:
			p0 = "season"
			p1 = "%02d"%(value+1)
		else:
			assert(false)
		var url = "res://import/demching-mahjong/{0}/{1}.svg".format([p0,p1])
		tiletypestr_to_texture_dict[tiletypestr] = load(url)
	return tiletypestr_to_texture_dict[tiletypestr]
