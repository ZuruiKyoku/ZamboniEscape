class_name Controls extends CanvasLayer

@onready var animation_player = $AnimationPlayer
@onready var player = $Panel/HBoxContainer/HowToPlay/GridContainer/Player

# Called when the node enters the scene tree for the first time.
func _ready():
	GetPlayerTexCord()
	animation_player.play("Spring_In")


func _on_main_menu_button_up():
	GameManager.currentState = GameManager.GameState.GotoMain
	animation_player.play("Spring_Out")


func _on_animation_player_animation_finished(anim_name):
	if anim_name == "Spring_Out":
		queue_free()

func GetPlayerTexCord():
	var team = Globals.user_prefs["playerTeam"]
	var tempTeam:float = team
	var x:float = (19 * floor(team % 8))
	var y:float = (40 * floor(tempTeam / 8))
	#Position then Size
	player.texture.region = Rect2(x,y,19,40)
