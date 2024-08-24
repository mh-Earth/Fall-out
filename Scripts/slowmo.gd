extends Area2D

@onready var timer = $Timer
@export_range(0,1) var slowmo_speed = 0.4
@export_range(0,3) var slowmo_duration = 0.2
@export_range(0,1) var smoothing = 0.05
var isSlowmo:String = ""
func _ready():
	timer.wait_time = slowmo_duration

func _on_body_entered(_body):
	Engine.time_scale = slowmo_speed
	isSlowmo = "start"
	timer.start()


func _on_timer_timeout():
	isSlowmo = 'end'
	
func _process(_delta):
	match isSlowmo:
		'start':
			if Engine.time_scale >= slowmo_duration:
				Engine.time_scale -= smoothing
		'end':
			if Engine.time_scale < 1:
				Engine.time_scale += smoothing
