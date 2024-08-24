extends Node2D

#signals
signal level_ended
#game variables
const FALLING_DELAY:float = 0.18 # min 1.5
var isFalling:bool = false
var GameOver:bool = false
var level_end:bool = false:
	set(value):
		level_end = value
		if value == true:
			level_ended.emit()
#player variables
const playerHasPassed = 'playerHasPassed'
var isPlayerAlive:bool = true
const PLAYER_SPEED = 100.0
var PLAYER_JUMP_VELOCITY = -300
var player_gravity:int = ProjectSettings.get_setting("physics/2d/default_gravity"):
	set(value):
		player_gravity = value
		print("player gravity changes")
		PLAYER_JUMP_VELOCITY = -(value * 0.31)

#collision lasyer
var falling_layer:int = 9
var fallable_layer:int =2
#jumper variables
var jumper_force = -500
const jumper_force_increaser = 50
var jumper_max_force = -700
#power ups vairables
const player_speed_increaser = 100
var player_max_speed = 500
#health bar 
var health_bar_max = 25
