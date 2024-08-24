extends Marker2D

const PLAYER = preload("res://Scene/player.tscn")
var current_level_node = null
func _ready():
	var root = get_tree().root
	current_level_node =  root.get_child(root.get_child_count()-1)
	#connectiong signals
	current_level_node.level_started.connect(sumomplayer)
	#sumomplayer.connect(current_level_node.level_stated)

func sumomplayer():
	print("player summomned")
	var player = PLAYER.instantiate()
	current_level_node.add_child(player)
	player.set_unique_name_in_owner(true)
	player.global_position = global_position
	

	
