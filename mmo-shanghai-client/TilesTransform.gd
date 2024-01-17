extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	get_viewport().size_changed.connect(fix_transform)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

var bound_rect
func store_bound_rect():
	bound_rect = $Tiles.get_bound_rect()

func fix_transform():
	var bound_rect_size = bound_rect[1] - bound_rect[0]
	var bound_rect_mid = (bound_rect[0] + bound_rect[1])/2
	var viewport_size = get_viewport().get_visible_rect().size
	var scale = min(viewport_size.x / bound_rect_size.x, viewport_size.y / bound_rect_size.y)
	self.scale = Vector2(scale, scale)
	self.position = viewport_size/2 - bound_rect_mid*scale
