class_name StartScreen extends Control

const BUTTON_CLICK_PARTICLES = preload("res://Menus/button_click_particles.tscn")

@onready var menuButtons_container = $MenuButtons
@onready var start = %Start
@onready var animation_player = $AnimationPlayer


# These 4 lines are not covered in the initial video. They've been added here just to make it easier for you
# to differentiate versions. I had not intended to provide updates so this feature was skipped in original code.
@onready var version_num: Label = %VersionNum
func _ready() -> void:
	version_num.text = "V %s" % str(ProjectSettings.get_setting("application/config/version"))
	
	for mb in menuButtons_container.get_children():
		var _mbNode = mb
		menuButtons_container.get_node(_mbNode.get_path()).button_up.connect(handle_menu_button_up.bind(_mbNode))
		menuButtons_container.get_node(_mbNode.get_path()).mouse_entered.connect(handle_menu_button_hover.bind(_mbNode))
		menuButtons_container.get_node(_mbNode.get_path()).focus_entered.connect(handle_focus_enter.bind(_mbNode))
		menuButtons_container.get_node(_mbNode.get_path()).focus_exited.connect(handle_focus_exit.bind(_mbNode))
	
	OnMain()
	
func _process(_delta):
	if GameManager.currentState == GameManager.GameState.GotoMain:
		OnMain()
		
func handle_menu_button_up(mb:Button):
	var parts = BUTTON_CLICK_PARTICLES.instantiate()
	parts.position = mb.pivot_offset
	parts.emitting = true
	mb.add_child(parts)
	
	match mb.name:
		"Start":
			Globals.user_prefs["TimesPlayed"] = Globals.user_prefs.increaseValue(Globals.user_prefs["TimesPlayed"])
			SceneManager.swap_scenes(SceneRegistry.levels["game_start"],get_tree().root,self,"zamboni_to_right")
		"TeamSelect":
			Globals.open_team_select()
		"Settings":
			Globals.open_settings_menu()
		"Quit":
			SceneManager.swap_scenes(SceneRegistry.main_scenes["Quit"],get_tree().root,self,"quit_to")
		"Stats":
			Globals.open_stats()
		"Leaderboards":
			Globals.open_leaderboards()
		"Controls":
			Globals.open_controls()

func handle_menu_button_hover(mb:Button):
	mb.grab_focus()	
		
func handle_focus_enter(mb:Button):
	if animation_player.has_animation(mb.name):
		animation_player.play(mb.name)	

func handle_focus_exit(_mb:Button):
	animation_player.stop()

func OnMain():
	GameManager.currentState = GameManager.GameState.MainMenu
	start.grab_focus()
