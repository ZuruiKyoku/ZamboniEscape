extends Node2D

@onready var animation_player = $AnimationPlayer

var powerup = ""

func _ready():
	if animation_player.has_animation(powerup):
		animation_player.play(powerup)
		await animation_player.animation_finished
		queue_free()
		
func SetPowerup(pu):
	powerup = pu
	
func remove():
	queue_free()
