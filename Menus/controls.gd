class_name Controls extends CanvasLayer

@onready var animation_player = $AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready():
	animation_player.play("Spring_In")


func _on_main_menu_button_up():
	GameManager.currentState = GameManager.GameState.GotoMain
	animation_player.play("Spring_Out")


func _on_animation_player_animation_finished(anim_name):
	if anim_name == "Spring_Out":
		queue_free()
