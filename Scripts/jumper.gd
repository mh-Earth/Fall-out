extends Node2D

var is_fallable = true
@onready var animation_player = $AnimationPlayer
@onready var player = %player
@onready var ray_cast = $RayCast

signal playerOnJumper
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var dir = Vector2.ZERO
#var name:String = 'jumper'
func _ready():
	player.connect('playerOnFallableBlock',reset)

func _physics_process(delta):
	if not ray_cast.is_colliding():
		position.y += 150 * delta

func rotation_to_direction():
   # Get the rotation of the node (in radians)
	var rotation_angle = rotation

	# Convert the rotation to a directional vector
	var direction = Vector2(cos(rotation_degrees), sin(rotation_degrees))

	# Move the node in the direction of its rotation
	return direction

func _on_jump_trigger_area_body_entered(_body):
	#playerOnJumper.emit()
	animation_player.play("on")
	if animation_player.animation_started:
		
		player.player_on_jumper(rotation_to_direction())
		if GameManager.jumper_force > GameManager.jumper_max_force:
			GameManager.jumper_force -= GameManager.jumper_force_increaser
			
	pass # Replace with function body.

func reset():
	GameManager.jumper_force = -500

func _on_distroy_zone_area_entered(_area):
	queue_free()
