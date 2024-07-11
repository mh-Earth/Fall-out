extends RigidBody2D
@onready var timer = $Timer
@onready var sprite = $Sprite2D
#@onready var collision_shape = $CollisionShape2D
@onready var ray_cast_left = $RayCastLeft
@onready var ray_cast_right = $RayCastRight
@onready var player_detection_area = $"player detection area"
#exprotts
@export var active_on_load:bool = false
@export var platfrom:bool = false
var moving:bool
var speed:int = 20
var is_ground = true
var is_fallable = true

var is_falling:bool = false
func _ready():
	add_to_group('ground')
	moving = active_on_load
	timer.wait_time = GameManager.FALLING_DELAY
	#timer.wait_time = 1
	if platfrom :
		player_detection_area.connect("body_exited",_on_player_detection_area_body_exited)
		

func start_falling_timer():
	timer.start()

func _on_timer_timeout():
	start_falling()
	
func start_falling():
	is_falling = true
	gravity_scale = 1

func _process(delta):
	if not is_falling and moving:
		if ray_cast_right.is_colliding() or ray_cast_left.is_colliding():
			speed *= -1
		position.x += speed * delta

func _on_player_detection_area_body_exited(body):
	timer.wait_time += 1.5


func _on_player_detection_area_body_entered(body):
	if not moving:
		moving = true
	
