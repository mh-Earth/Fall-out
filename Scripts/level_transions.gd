extends CanvasLayer

@onready var animation_player = $AnimationPlayer


func _ready():
	visible = true

func fade_in():
	animation_player.play("fade in")
	
func fade_out():
	animation_player.play("fade out")
