extends Area2D

@onready var animation_player = $AnimationPlayer
var player

func _on_timer_timeout():
	queue_free()


func _on_body_entered(body):
	if body == player:
		GameManager.increasePucks()
		animation_player.play("Pickup")
