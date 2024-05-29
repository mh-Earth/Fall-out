extends Area2D

@onready var player = %player
@onready var camera = %Camera2D
@onready var trigger = $trigger
@onready var rest = $rest


func _ready():
	#connect("body_entered",_on_body_entered)
	#rest.disabled = true
	pass
#
#
#func _on_body_entered(body):
	#camera.limit_bottom = 100000
	#pass # Replace with function body.
