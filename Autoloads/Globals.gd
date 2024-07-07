extends Node

@onready var SFX_BUS_ID = AudioServer.get_bus_index("SFX")
@onready var MUSIC_BUS_ID = AudioServer.get_bus_index("Music")

var user_prefs:UserPrefs
var game_info: GameInfo
var save:SaveData
#var user_save:UserSave

# temp - I'm not wild about preloads, but this menu is fairly light (to revise in a future version)
var settings_menu_scene:PackedScene = preload("res://Menus/settings_menu.tscn")
var settings_menu = null
var display_manager: DisplayManager

var game_over_scene:PackedScene = preload("res://Menus/game_over.tscn")
var game_over = null

var team_select_scene:PackedScene = preload("res://Menus/team_select.tscn")
var team_select = null

var leaderboards_scene:PackedScene = preload("res://Menus/leaderboards.tscn")
var leaderboards = null

var stats_scene:PackedScene = preload("res://Menus/stats.tscn")
var stats = null

var controls_scene:PackedScene = preload("res://Menus/how_to.tscn")
var controls = null

func _ready():
	# setup so that we can intercept quit
	get_tree().set_auto_accept_quit(false)
	
	user_prefs = UserPrefs.load_or_create()
	game_info = GameInfo.load_or_create()
	
	display_manager = DisplayManager.new()
	
	# SaveData extends JSONLoader to add methods to read and write data specifically for this game
	# customize SaveData to fit your game. What's in this repo is just a very basic example.
	save = SaveData.new()
	save.load_or_create()
	
	# todo - will implement Resource saver option in future versions
	#user_save = UserSave.load_or_create() as UserSave
	#user_save.save()
	
	# temp - Will probably relocate to an audio-specfiic class in future versions
	AudioServer.set_bus_volume_db(SFX_BUS_ID, linear_to_db(user_prefs.sfx_volume))
	AudioServer.set_bus_mute(SFX_BUS_ID, user_prefs.sfx_volume < .05)
	AudioServer.set_bus_volume_db(MUSIC_BUS_ID, linear_to_db(user_prefs.music_volume))
	AudioServer.set_bus_mute(MUSIC_BUS_ID, user_prefs.music_volume < .05)
	
	#SilentWolf Leaderboard
	SilentWolf.configure({
		"api_key": "8o1S0MUyjQ6DSnlAmN1nA2UPHwvw86pD2cvRdysq",
		"game_id": "zamboniescape",
		"log_level": 1
		})
		
	SilentWolf.configure_scores({
		"open_scene_on_close": SceneRegistry.main_scenes["StartScreen"]
		})

enum GLOBAL_STATE {
	MAIN_MENU,
	TEAM_SELECT,
	PLAYING,
	PAUSED,
	GAMEOVER,
	LEADERBOARDS,
	GOTO_MAIN,
	GOTO_PLAY,
	GOTO_GAMEOVER
}

var currentState:GLOBAL_STATE = GLOBAL_STATE.MAIN_MENU


const LANGUAGES:Dictionary = {
	0:"en-US",
	1:"es-LAT"
}

func get_selected_language() -> String:
	var s:String = LANGUAGES[user_prefs.language]
	if s:
		return s
	return LANGUAGES[0]

# temp - maybe the settings menu doesn't need to live in a global spot? (will decide in future version)
func open_settings_menu():
	if not settings_menu:
		if GameManager.currentState == GameManager.GameState.Playing:
			GameManager.currentState = GameManager.GameState.Paused
		settings_menu = settings_menu_scene.instantiate()
		get_tree().root.add_child(settings_menu)
	else:
		push_warning('SETTINGS MENU already exists in this scene')
		
func open_team_select():
	if not team_select:
		team_select = team_select_scene.instantiate()
		get_tree().root.add_child(team_select)
	else:
		push_warning('TEAM SELECT already exists in this scene')
		
func open_leaderboards():
	if not leaderboards:
		leaderboards = leaderboards_scene.instantiate()
		get_tree().root.add_child(leaderboards)
	else:
		push_warning('LEADERBOARDS already exists in this scene')
		
func open_stats():
	if not stats:
		stats = stats_scene.instantiate()
		get_tree().root.add_child(stats)
	else:
		push_warning('STATS already exists in this scene')
		
func open_controls():
	if not controls:
		controls = controls_scene.instantiate()
		get_tree().root.add_child(controls)
	else:
		push_warning('STATS already exists in this scene')
		
func open_game_over():
	if not game_over:
		game_over = game_over_scene.instantiate()
		get_tree().root.add_child(game_over)
	else:
		push_warning('GAME OVER already exists in this scene')

func quit():
	# todo add confirmation dialog before quitting
	Globals.user_prefs.save()
	get_tree().quit() # default behavior
	display_manager.save_window()

func _notification(what):
	# intercept window manager quit
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		quit()
