class_name Stats extends CanvasLayer

@onready var animation_player = $AnimationPlayer
@onready var player_values = %PlayerValues
@onready var powerup_values = %PowerupValues


# Called when the node enters the scene tree for the first time.
func _ready():
	getValues()
	animation_player.play("Spring_In")

func getValues():
	player_values.get_node("TimesPlayed").text = str(Globals.user_prefs.decryptValue(Globals.user_prefs["TimesPlayed"]))
	player_values.get_node("Deaths").text = str(Globals.user_prefs.decryptValue(Globals.user_prefs["Deaths"]))

func _on_close_button_up():
	GameManager.currentState = GameManager.GameState.GotoMain
	animation_player.play("Spring_Out")
	await animation_player.animation_finished
	queue_free()
