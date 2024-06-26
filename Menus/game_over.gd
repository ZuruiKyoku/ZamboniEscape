class_name GameOver extends CanvasLayer

@onready var animation_player = $AnimationPlayer
@onready var main_menu = $Panel/BackgroundPanel/MarginContainer/VBoxContainer/HBoxContainer/MainMenu
@onready var retry = $Panel/BackgroundPanel/MarginContainer/VBoxContainer/HBoxContainer/Retry
@onready var new_high = $Panel/BackgroundPanel/MarginContainer/VBoxContainer/NewHigh
@onready var score = $Panel/BackgroundPanel/MarginContainer/VBoxContainer/Score
@onready var player_name = %PlayerName
@onready var submit_score = $Panel/BackgroundPanel/MarginContainer/VBoxContainer/SubmitScore
@onready var saving = $Saving
@onready var saved = $Saved

func _ready():
	score.text = str(GameManager.decryptValue(GameManager.playerScore))
	player_name.text = Globals.user_prefs.playerName
	animation_player.play("Spring_In")


func _on_main_menu_button_up():
	GameManager.currentState = GameManager.GameState.GotoMain
	queue_free()
	

#move into game scenen and queue_free this scene
func _on_retry_button_up():
	GameManager.currentState = GameManager.GameState.GotoPlay
	queue_free()
	

func _on_submit_score_button_up():
	if player_name.text != "":
		Globals.user_prefs.playerName = player_name.text
		saving.visible = true
		var _sw_result: Dictionary = await SilentWolf.Scores.save_score(player_name.text, GameManager.decryptValue(GameManager.playerScore)).sw_save_score_complete
		
		submit_score.disabled = true
		saving.visible = false
		saved.visible = true
		await get_tree().create_timer(1.5).timeout
		saved.visible = false
		
		main_menu.grab_focus()
