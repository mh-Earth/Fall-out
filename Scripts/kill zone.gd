extends Area2D


signal gameover

func _on_body_entered(body):
	#print(body)
	if body.has_signal('playerMoved'):
		gameover.emit()
		GameManager.isPlayerAlive = false
		return
	body.queue_free()
	#pass
	
