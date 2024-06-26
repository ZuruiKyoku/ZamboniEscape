extends Line2D

const FLAMES = preload("res://Gameplay/Assets/scenes/flames.tscn")
@export var length = 50
var point = Vector2()

func _process(_delta):
	global_position = Vector2(0,0)
	global_rotation = 0
	
	point = get_parent().global_position
	
	if get_parent().name == "Player" && GameManager.fireTrailActive:
		var newFlame = FLAMES.instantiate()
		newFlame.emitting = true
		newFlame.global_position = get_parent().global_position
		add_child(newFlame)
	
	add_point(point)
	while get_point_count() > length:
		remove_point(0)
