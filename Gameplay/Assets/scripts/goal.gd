extends Area2D

func _on_body_entered(body):
	if body.name.contains("Puck"):
		body.queue_free()
		GameManager.increaseGoals()
