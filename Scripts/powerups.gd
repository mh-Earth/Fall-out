extends Area2D


@export_enum("speedup","speeddown","die") var powertype:String
@onready var player = %player
@onready var power_timeout = $power_timeout
@onready var collision_shape = $CollisionShape2D
@onready var sprite = $Sprite2D
@onready var ray_cast = $RayCast2D
@onready var sprite_2d = $Sprite2D
@export var rotation_speed:int


func _process(delta):
	sprite_2d.rotation_degrees += 10
	if not ray_cast.is_colliding():
		position.y += rotation_speed * delta

func _ready():
	add_to_group("powerups")
	connect('body_entered',_on_body_entered)
	#match_color()

func match_color():
	match powertype:
		"speedup":sprite.modulate = Color("gray")
		"speeddown":sprite.modulate = Color("red")

func time_up():
	print("time_up")
	match powertype:
		"speedup":
			player.player_speed = GameManager.PLAYER_SPEED
		"speeddown":
			player.player_speed = GameManager.PLAYER_SPEED
		"die":
			GameManager.GameOver = true
		

func _on_body_entered(body):
	#if player
	match powertype:
		"speedup":
			if body.player_speed < GameManager.player_max_speed:
				power_timeout.wait_time += 0.5
				body.player_speed += GameManager.player_speed_increaser
			
		"speeddown":
			power_timeout.wait_time += 0.5
			body.player_speed -= 25
		"die":
			#body.set_collision_layer_value(1,false)
			#body.set_collision_layer_value(GameManager.fallable_layer,true)
			power_timeout.wait_time += 0.5
			GameManager.GameOver = true
			
	power_timeout.start()
	visible = false
	collision_shape.set_deferred("disabled","true")
	print("powerup")
	#queue_free()


func _on_power_timeout_timeout():
	time_up()
