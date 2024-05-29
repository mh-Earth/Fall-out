extends StaticBody2D

signal player_reach_end
@onready var player = %player
@onready var timer = $Timer

var elevating_speed:int = 0
var current_level_node = null
func _ready():
	add_to_group('end_block')
	var root = get_tree().root
	current_level_node =  root.get_child(root.get_child_count()-1)
	#connectiong signals
	player_reach_end.connect(current_level_node._on_end_block_player_reach_end)
	

func _process(delta):
	if GameManager.level_end:
		position.y -= elevating_speed * delta
	
func _on_area_2d_body_entered(_body):
	player_reach_end.emit()
	player.position.x = position.x
	timer.start()


func _on_timer_timeout():
	elevating_speed = 40
	
	
