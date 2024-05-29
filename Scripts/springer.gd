extends StaticBody2D
@onready var damped_spring_joint = $DampedSpringJoint2D


func _on_area_2d_body_entered(body):
	print(body)
	damped_spring_joint.node_b = body.get_path()
