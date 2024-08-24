extends RigidBody2D
@onready var timer = $Timer
@onready var sprite = $Sprite2D
#@onready var collision_shape = $CollisionShape2D
@onready var light_occluder = $LightOccluder2D

var is_ground = true
var is_fallable = true
var is_falling = false
func _ready():
	add_to_group('ground')
	timer.wait_time = GameManager.FALLING_DELAY

func start_falling_timer():
	timer.start()

func _on_timer_timeout():
	#light_occluder.visible = false
	is_falling = true
	start_falling()
	
func start_falling():
	#modulate = Color('red')
	gravity_scale = 1
