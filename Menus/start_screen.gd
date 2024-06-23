class_name StartScreen extends Control

@onready var start = $VBoxContainer/HBoxContainer/GridContainer/Start

# These 4 lines are not covered in the initial video. They've been added here just to make it easier for you
# to differentiate versions. I had not intended to provide updates so this feature was skipped in original code.
@onready var version_num: Label = %VersionNum
func _ready() -> void:
	version_num.text = "V %s" % str(ProjectSettings.get_setting("application/config/version"))
	OnMain()
	
func _process(_delta):
	if GameManager.currentState == GameManager.GameState.GotoMain:
		OnMain()

func _on_start_button_up() -> void:	
	Globals.user_prefs["TimesPlayed"] = Globals.user_prefs.increaseValue(Globals.user_prefs["TimesPlayed"])
	SceneManager.swap_scenes(SceneRegistry.levels["game_start"],get_tree().root,self,"zamboni_to_right")

func _on_team_select_button_up():
	Globals.open_team_select()
	
func _on_settings_button_up() -> void:
	Globals.open_settings_menu()

func _on_quit_button_up() -> void:
	SceneManager.swap_scenes(SceneRegistry.main_scenes["Quit"],get_tree().root,self,"quit_to")

func OnMain():
	GameManager.currentState = GameManager.GameState.MainMenu
	start.grab_focus()

func _on_leaderboards_button_up():
	Globals.open_leaderboards()


func _on_stats_button_up():
	Globals.open_stats()
