extends Node2D

@onready var fall_able_blocks = %FallAbleBlocks
@onready var game_over_timer = $GameOverTimer
@onready var transtions_layer = %"Transtions layer"
@onready var progress_bar = $UI/TextureProgressBar
@onready var progress_value = $UI/progress_value
@onready var player_speed_lable = $UI/player_speed
@onready var player = %player

@export_file var next_scene:String

var isPlayerFalls:bool = false

func _ready():
	GameManager.level_end = false
	GameManager.isPlayerAlive = true
	GameManager.isFalling = false
	# Scene opning transition
	transtions_layer.fade_in()
	
func start_game_play():
	start_falling()

func after_player_die_scene():
	#adding fallableblock to 'fallingblocks' group
	var blockInFallableblocks = fall_able_blocks.get_children()
	for block in blockInFallableblocks:
		block.add_to_group("fallingblocks")
	isPlayerFalls = true

func  _process(_delta):
	#print(GameManager.isFalling)
	player_speed_lable.text = "player speed:" + str(player.velocity.x)
	
	if GameManager.isFalling:
		var fallableblocksinscene = get_tree().get_nodes_in_group("fallableblocks")
		#var playerHasPassed = get_tree().get_nodes_in_group(GameManager.playerHasPassed)
		progress_bar.value = len(fallableblocksinscene)
		progress_value.text = str(len(fallableblocksinscene))
		
#		if player touch the last falling block.Means player is falling
		if len(fallableblocksinscene) == 0 or not GameManager.isPlayerAlive:
			after_player_die_scene()
			return
			
		for block in fallableblocksinscene:
			if GameManager.isPlayerAlive:
				#block.modulate = Color('green')
				block.start_falling_timer()
				await get_tree().create_timer(GameManager.FALLING_DELAY).timeout
				
				if is_instance_valid(block):
					block.remove_from_group('fallableblocks')
					block.set_collision_layer_value(GameManager.falling_layer,false)
					block.set_collision_layer_value(GameManager.fallable_layer,true)
				break
			
	elif isPlayerFalls and not GameManager.level_end:
		var fallableblocksinscene = get_tree().get_nodes_in_group("fallingblocks")
		for block in fallableblocksinscene:
			block.start_falling()
			await get_tree().create_timer(GameManager.FALLING_DELAY).timeout
			if is_instance_valid(block):
				block.remove_from_group('fallingblocks')
			break
		
			
func start_falling():
	GameManager.isFalling = true
	
func stop_falling():
	GameManager.isFalling = false
	
func _on_player_player_moved():
	if not GameManager.isFalling and not GameManager.level_end: #true
		start_game_play()
		
func _on_end_block_player_reach_end():
	print("player reached end signal")
	GameManager.level_end = true #only making true here
	stop_falling()
	await get_tree().create_timer(1.5).timeout
	start_end_transition()

func _on_kill_zone_gameover():
	# load after players die scene
	after_player_die_scene()
	game_over_timer.start()
	start_end_transition()
	await get_tree().create_timer(1.5).timeout


func _on_game_over_timer_timeout():
	get_tree().reload_current_scene()

#region level transion
func start_end_transition():
	#print()
	transtions_layer.fade_out()
	await get_tree().create_timer(1.5).timeout
	if is_inside_tree():
		get_tree().change_scene_to_file(next_scene)
		print("Scene loaded")
	else:
		print("Scene dosen't load because of 'is_inside_tree' function")
	

#region
