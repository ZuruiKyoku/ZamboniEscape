extends Area2D

@onready var animation_player = $AnimationPlayer
var player

func _ready():
	pass

func _on_timer_timeout():
	queue_free()


func _on_body_entered(body):
	if body == player:
		GameManager.increasePucks()
		Globals.user_prefs["PucksCollected"] = Globals.user_prefs.increaseValue(Globals.user_prefs["PucksCollected"])
		animation_player.play("Pickup")
