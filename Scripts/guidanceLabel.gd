extends Label




func _on_area_2d_body_entered(_body):
	var tween = get_tree().create_tween()
	tween.tween_property(self,"modulate",Color('white',0),0.65)
