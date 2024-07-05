extends Node2D

@onready var animation_player = $AnimationPlayer
var side = ""

func _ready():
	if animation_player.has_animation(side):
		animation_player.play(side)
		
func SetSide(tempSide):
	side = tempSide
	
func remove():
	queue_free()
