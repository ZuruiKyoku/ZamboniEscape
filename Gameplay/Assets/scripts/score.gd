extends Node2D

@onready var animation_player = $AnimationPlayer
var side = ""

func _ready():
	if side == "NetRight":
		animation_player.play("GoalRight")
	elif side == "NetLeft":
		animation_player.play("GoalLeft")
		
func SetSide(tempSide):
	side = tempSide
	
func remove():
	queue_free()
