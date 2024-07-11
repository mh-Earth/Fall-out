extends RigidBody2D


@export_enum("speedup","speeddown","die") var powertype:String
@onready var player = %player
@onready var power_timeout = $power_timeout
@onready var sprite = $Sprite2D
#@onready var ray_cast = $RayCast2D
@onready var sprite_2d = $Sprite2D
@export var rotation_speed:int
@onready var collision_shape = $Area2D/CollisionShape2D


func _process(delta):
	sprite_2d.rotation_degrees += rotation_speed
	#if not ray_cast.is_colliding():
		#position.y += rotation_speed * delta

func _ready():
	add_to_group("powerups")
	add_to_group("fallingblocks")
	#connect('body_entered',_on_body_entered)
	#match_color()

func match_color():
	match powertype:
		"speedup":sprite.modulate = Color("gray")
		"speeddown":sprite.modulate = Color("red")

func time_up():
	match powertype:
		"speedup":
			var tween = get_tree().create_tween()
			tween.tween_property(player,'player_speed',GameManager.PLAYER_SPEED,.3)
		"speeddown":
			var tween = get_tree().create_tween()
			tween.tween_property(player,'player_speed',GameManager.PLAYER_SPEED,.3)
		"die":
			GameManager.GameOver = true
		


func _on_timer_timeout():
	time_up()


func _on_area_2d_body_entered(body):
		#if player
	match powertype:
		"speedup":
			if body.player_speed < GameManager.player_max_speed:
				power_timeout.wait_time += 0.5
				var tween = get_tree().create_tween()
				tween.tween_property(body,'player_speed',body.player_speed+GameManager.player_speed_increaser,.1)
				
			
		"speeddown":
			power_timeout.wait_time += 0.5
			var tween = get_tree().create_tween()
			tween.tween_property(body,'player_speed',body.player_speed - 25,.1)
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

 # Replace with function body.
