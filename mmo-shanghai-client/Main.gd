extends Control

var rng = RandomNumberGenerator.new()
var board_scene = preload("res://Board.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	rng.randomize()
	start_game()
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

var board_node
func start_game():
	assert(board_node == null)
	board_node = board_scene.instantiate()
	#board_node.status_no_pair.connect($StatusNoPair._on_board_status_no_pair)
	$GameSlot.add_child(board_node)
	var seed = rng.randi()+rng.randi()<<32
	board_node.init_new_game(seed)


func _on_tips_button_pressed():
	print("_on_tips_button_pressed")
	board_node.show_tips()
