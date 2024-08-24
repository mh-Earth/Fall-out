extends RigidBody2D


@export_enum("none","speedup","speeddown","die","slowfalling","levetation") var powertype:String
## Power ups duration
@export var duration:float = 1
## Only works if power type in levetation
@export_range(0,980) var levetation_strength:int = 200
## Only works if power type in slowfalling
@export_range(0,980) var slowfalling_strength:int = 900

@onready var player = %player
@onready var power_duration_timer = $power_timeout
@onready var sprite = $Sprite2D
#@onready var ray_cast = $RayCast2D
@onready var sprite_2d = $Sprite2D
@export var rotation_speed:int = 1000
@onready var collision_shape = $Area2D/CollisionShape2D


func _process(_delta):
	sprite_2d.rotation_degrees += rotation_speed
	#if not ray_cast.is_colliding():
		#position.y += rotation_speed * delta

func _ready():
	add_to_group("powerups")
	add_to_group("fallingblocks")
	power_duration_timer.wait_time = duration
	

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
		"slowfalling":
			#var tween = get_tree().create_tween()
			#tween.tween_property(player,'velocity:y',0,.5)
			player.velocity.y = 0
			GameManager.player_gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
		"levetation":
			GameManager.player_gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
		"none":
			pass
	


func _on_timer_timeout():
	time_up()


func _on_area_2d_body_entered(body):
		#if player
	match powertype:
		"speedup":
			if body.player_speed < GameManager.player_max_speed:
				power_duration_timer.wait_time += 0.5
				var tween = get_tree().create_tween()
				tween.tween_property(body,'player_speed',body.player_speed+GameManager.player_speed_increaser,.1)
				
			
		"speeddown":
			power_duration_timer.wait_time += 0.5
			var tween = get_tree().create_tween()
			tween.tween_property(body,'player_speed',body.player_speed - 25,.1)
		"die":
			player.playerDieFromPowerUp()
		"slowfalling":
			player.velocity.y = 0
			GameManager.player_gravity  -= slowfalling_strength
		"levetation":
			player.position.y -= 1
			GameManager.player_gravity -= ProjectSettings.get_setting("physics/2d/default_gravity") + levetation_strength
		"none":
			pass
			
			
			
	power_duration_timer.start()
	visible = false
	collision_shape.set_deferred("disabled","true")
	print("powerup")
