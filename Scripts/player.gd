extends CharacterBody2D

#signals
signal playerMoved
signal playerOnFallableBlock
signal player_die
var player_speed = GameManager.PLAYER_SPEED

var alive:bool = true
# Get the gravity from the project settings to be synced with RigidBody nodes.
@onready var animated_sprite = $AnimatedSprite2D
@onready var ray_cast_m = $RayCastM
@onready var ray_cast_l = $RayCastL
@onready var ray_cast_r = $RayCastR
@onready var groundcheckraycast = $groundcheckraycast

@onready var raycasts:Array[RayCast2D] = [ray_cast_m,ray_cast_l,ray_cast_r]
#func _ready():

func checkPlayerGroundBlock():
	if groundcheckraycast.is_colliding():
		#if ground is a platfrom
		var collaider = groundcheckraycast.get_collider()
		if is_instance_valid(collaider):
			if not collaider.is_in_group('jumper'):
				playerOnFallableBlock.emit()
		
		
	

func _process(_delta):
	for ray_cast in raycasts:
		if ray_cast.is_colliding():
			var collider = ray_cast.get_collider()
			if is_instance_valid(collider):
				var current_group = get_tree().get_nodes_in_group("fallableblocks")
				if collider not in current_group:
					collider.add_to_group('fallableblocks')
	checkPlayerGroundBlock()

func gameover():
	pass

func playerDieFromPowerUp():
	velocity.x = 0
	alive = false
	animated_sprite.play("die")
	player_die.emit()
	
func player_on_jumper(_dir):
	velocity.y =  GameManager.jumper_force

func _physics_process(delta):
	# Add the gravity.
	if is_on_floor():
		for ray_cast in raycasts:
			ray_cast.target_position.y = 20
			
		
	if not is_on_floor():
		velocity.y += GameManager.player_gravity * delta
		for ray_cast in raycasts:
			ray_cast.target_position.y = 75
		
			
		
	if alive:
		# Handle jump.
		if Input.is_action_just_pressed("jump") and is_on_floor():
			velocity.y = GameManager.PLAYER_JUMP_VELOCITY
			
		# Get the input direction and handle the movement/deceleration.
		var direction = Input.get_axis("left", "right")
		
		#animations
		#animetion will only player if the player is alive
		if is_on_floor():
			if direction != 0 and not GameManager.level_end:
				animated_sprite.play("run")
			else:
				animated_sprite.play("idel")
		else:
			if velocity.y > 0 :
				animated_sprite.play("falling")
			if velocity.y < 0:
				animated_sprite.play("jump")
			
		if direction > 0:
			animated_sprite.flip_h = false
		elif direction < 0:
			animated_sprite.flip_h = true
			
		if direction and not GameManager.level_end:
			playerMoved.emit()
			velocity.x = direction * player_speed
		else:
			velocity.x = move_toward(velocity.x, 0, player_speed)

	move_and_slide()
