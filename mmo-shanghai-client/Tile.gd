extends Node2D

class_name Tile

# const WIDTH = 150
# const HEIGHT = 200
# const SIZE = Vector2(WIDTH, HEIGHT)
# const RECT = Rect2(-40, 0, WIDTH, HEIGHT+40)
const POS0 = Vector2(-40, 0)
const POS1 = Vector2(150, 200+40)

var z_ref:int = 0
var z_val:int = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	#set_tilebase(0)
	#set_tiletype([0,7])
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func set_tilebase(tilebaseid):
	$Base.texture = Tile.get_tilebase_texture(tilebaseid)

var tiletype
func set_tiletype(tiletype):
	self.tiletype = tiletype
	$Face.texture = Tile.get_tiletype_texture(tiletype)

const TILEXYZ_TO_POS_MAT = [
	[150,0,40,0],
	[0,200,-40,0],
]
const TILEXYZ_TO_Z_MAT = [
	[-3,4,500,0],
]
var tilexyz
func set_tilexyz(tilexyz):
	self.tilexyz = tilexyz
	var pos_ary = Common.dot21(TILEXYZ_TO_POS_MAT, tilexyz)
	var z_ary = Common.dot21(TILEXYZ_TO_Z_MAT, tilexyz)
	position = Vector2(pos_ary[0], pos_ary[1])
	z_ref = int(z_ary[0])

static var tiletypestr_to_texture_dict = {}
static func get_tiletype_texture(tiletype):
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

static var tilebaseid_to_texture_dict = {}
static func get_tilebase_texture(tilebaseid):
	if not tilebaseid_to_texture_dict.has(tilebaseid):
		var url = "res://import/demching-mahjong/tile/{0}/04.svg".format(["%02d"%tilebaseid])
		tilebaseid_to_texture_dict[tilebaseid] = load(url)
	return tilebaseid_to_texture_dict[tilebaseid]

signal mouse_entered(me)
func _on_area_2d_mouse_entered():
	#print("_on_area_2d_mouse_entered")
	mouse_entered.emit(self)
	#$Highlight.visible = true


signal mouse_exited(me)
func _on_area_2d_mouse_exited():
	mouse_exited.emit(self)
	#$Highlight.visible = false

signal mouse_pressed(me)
func _on_area_2d_input_event(viewport, event, shape_idx):
	#print(event.as_text())
	if     event.get_class() == "InputEventMouseButton" \
	   and event.button_index == MouseButton.MOUSE_BUTTON_LEFT \
	   and event.pressed:
		mouse_pressed.emit(self)


var highlight_enabled = false
func set_highlight(enable):
	highlight_enabled = enable
	$Highlight.visible = enable

func set_selected(enable):
	$Select.visible = enable

func get_close_top(other):
	var other_tilexyz = other.tilexyz
	if other_tilexyz[2] <= tilexyz[2]: return false
	if other_tilexyz[0] < tilexyz[0] - 1 + Common.EPSILON: return false
	if other_tilexyz[0] > tilexyz[0] + 1 - Common.EPSILON: return false
	if other_tilexyz[1] < tilexyz[1] - 1 + Common.EPSILON: return false
	if other_tilexyz[1] > tilexyz[1] + 1 - Common.EPSILON: return false
	return true

func get_close_left(other):
	var other_tilexyz = other.tilexyz
	if other_tilexyz[2] != tilexyz[2]: return false
	if other_tilexyz[0] < tilexyz[0] - 1 - Common.EPSILON: return false
	if other_tilexyz[0] > tilexyz[0] - 1 + Common.EPSILON: return false
	if other_tilexyz[1] < tilexyz[1] - 1 + Common.EPSILON: return false
	if other_tilexyz[1] > tilexyz[1] + 1 - Common.EPSILON: return false
	return true

func get_close_right(other):
	var other_tilexyz = other.tilexyz
	if other_tilexyz[2] != tilexyz[2]: return false
	if other_tilexyz[0] < tilexyz[0] + 1 - Common.EPSILON: return false
	if other_tilexyz[0] > tilexyz[0] + 1 + Common.EPSILON: return false
	if other_tilexyz[1] < tilexyz[1] - 1 + Common.EPSILON: return false
	if other_tilexyz[1] > tilexyz[1] + 1 - Common.EPSILON: return false
	return true

static func remove_match(tiletype0, tiletype1):
	if tiletype0 == tiletype1: return true
	if tiletype0[0] == 5 and tiletype1[0] == 5: return true
	if tiletype0[0] == 6 and tiletype1[0] == 6: return true
	return false
