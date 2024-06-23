extends Node2D

@onready var shot_part_effect = $ShotPartEffect

# Called when the node enters the scene tree for the first time.
func _ready():
	shot_part_effect.emitting = true

func _on_shot_part_effect_finished():
	queue_free()
