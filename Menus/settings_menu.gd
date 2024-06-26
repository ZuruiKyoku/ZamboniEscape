class_name SettingsMenu extends CanvasLayer

# opening this menu pauses the game, so you don't have to worry about blocking input
# from anything underneath it

signal language_changed(language: String)

@onready var window_mode_dropdown:OptionButton = %WindowModeDropdown
@onready var window_resolution_dropdown:OptionButton = %WindowResolutionDropdown
@onready var monitor_dropdown:OptionButton = %MonitorDropdown
@onready var master_slider:HSlider = %MasterSlider as HSlider
@onready var music_slider:HSlider = %MusicSlider as HSlider
@onready var sfx_slider:HSlider = %SFXSlider as HSlider
@onready var language_dropdown:OptionButton = %LanguageDropdown as OptionButton
@onready var menu_button = %MenuButton as Button
@onready var save_button:Button = %SaveButton as Button
@onready var close_button:Button = %CloseButton as Button
@onready var quit_button:Button = %QuitButton as Button
@onready var settings_tabs:TabContainer = %SettingsTabs
@onready var MASTER_BUS_ID = AudioServer.get_bus_index("Master")
@onready var SFX_BUS_ID = AudioServer.get_bus_index("SFX")
@onready var MUSIC_BUS_ID = AudioServer.get_bus_index("Music")
@onready var animation_player = $AnimationPlayer

func _ready():
	if OS.get_name() in ["Web", "iOS", "Android"]:
		# Display settings don't work for Web and Mobile
		settings_tabs.set_tab_disabled(1, true)
	elif OS.get_name() == "macOS":
		# MacOS borderless fullscreen behaves the same as fullscreen
		window_mode_dropdown.remove_item(2)
	
	for res in DisplayManager.window_resolutions:
		window_resolution_dropdown.add_item("%dx%d" % [res.x, res.y])
	
	for screen_idx in range(DisplayServer.get_screen_count()):
		monitor_dropdown.add_item("Monitor %d" % screen_idx)
	
	# load (or create) file with these saved preferences
	Globals.user_prefs = UserPrefs.load_or_create()
	
	if GameManager.currentState == GameManager.GameState.MainMenu:
		menu_button.visible = false
		quit_button.visible = false
	elif GameManager.currentState == GameManager.GameState.Playing:
		menu_button.visible = true
		quit_button.visible = true
		GameManager.currentState = GameManager.GameState.Paused
	
	# note - if you want the option to save your game from this menu, replace the hardcoded
	# false with logic that assures the game is in a savable state
	save_button.visible = false
	
	
	# set saved values (will be default values if first load)
	if master_slider:
		master_slider.value = Globals.user_prefs.master_volume
	if music_slider:
		music_slider.value = Globals.user_prefs.music_volume
	if sfx_slider:
		sfx_slider.value = Globals.user_prefs.sfx_volume
	if language_dropdown:
		language_dropdown.selected = Globals.user_prefs.language
	if window_mode_dropdown:
		window_mode_dropdown.selected = Globals.user_prefs.window_mode
	if window_resolution_dropdown:
		for idx: int in range(window_resolution_dropdown.item_count):
			if window_resolution_dropdown.get_item_text(idx) == \
			"%dx%d" % [Globals.user_prefs.window_resolution.x, Globals.user_prefs.window_resolution.y]:
				window_resolution_dropdown.selected = idx
	
	
	animation_player.play("Spring_In")

func _process(_delta):
	if Input.is_action_just_pressed("ui_cancel"):
		close_settings()

func close_settings():
	if GameManager.currentState != GameManager.GameState.Paused:
		GameManager.currentState = GameManager.GameState.GotoMain
	elif GameManager.currentState == GameManager.GameState.Paused:
		GameManager.currentState = GameManager.GameState.Playing
	animation_player.play("Spring_Out")

func goto_menu():
	GameManager.currentState = GameManager.GameState.GotoMain
	animation_player.play("Spring_Out")
	
func _on_close_button_pressed():
	close_settings()
	
func _on_menu_button_pressed():
	goto_menu()
	
func _on_save_button_pressed():
	print("save button pressed")
	# note - this is where I would/will put the ability for players to manually save data
	# Ex: something like the below
	# Globals.user_save.save_all_game_data()

func _on_quit_button_pressed():
	# https://docs.godotengine.org/en/stable/tutorials/inputs/handling_quit_requests.html
	# todo - are you sure prompt
	# todo - save before quitting if in-game
	GameManager.currentState = GameManager.GameState.Quit
	queue_free()

func _on_window_mode_option_selected(_value):
	Globals.user_prefs.window_mode = _value
	Globals.display_manager.set_window_mode(_value)

func _on_window_resolution_option_selected(_value):
	Globals.user_prefs.window_resolution = DisplayManager.window_resolutions[_value]
	Globals.display_manager.set_window_resolution(DisplayManager.window_resolutions[_value])

func _on_monitor_option_selected(_value: int):
	Globals.user_prefs.window_monitor = _value
	Globals.display_manager.set_monitor(_value)
	
func _on_master_slider_value_changed(_value):
	AudioServer.set_bus_volume_db(MASTER_BUS_ID, linear_to_db(_value))
	AudioServer.set_bus_mute(MASTER_BUS_ID, _value < .05)
	Globals.user_prefs.master_volume = _value

func _on_music_slider_value_changed(_value):
	AudioServer.set_bus_volume_db(MUSIC_BUS_ID, linear_to_db(_value))
	AudioServer.set_bus_mute(MUSIC_BUS_ID, _value < .05)
	Globals.user_prefs.music_volume = _value

func _on_sfx_slider_value_changed(_value):
	AudioServer.set_bus_volume_db(SFX_BUS_ID, linear_to_db(_value))
	AudioServer.set_bus_mute(SFX_BUS_ID, _value < .05)
	Globals.user_prefs.sfx_volume = _value

func _on_language_dropdown_item_selected(_index):
	# todo - set selected language
	Globals.user_prefs.language = _index
	# todo - needs to be wired to a more central place for handling loc (planned for future version)
	language_changed.emit(_index)

func _notification(what):
	match what:
		NOTIFICATION_ENTER_TREE:
			get_tree().paused = true
		NOTIFICATION_EXIT_TREE:
			Globals.user_prefs.save()
			get_tree().paused = false

func _on_animation_player_animation_finished(anim_name):
	if anim_name == "Spring_Out":
		queue_free()

func _on_menu_button_mouse_entered():
	menu_button.grab_focus()

func _on_save_button_mouse_entered():
	save_button.grab_focus()

func _on_close_button_mouse_entered():
	close_button.grab_focus()

func _on_quit_button_mouse_entered():
	quit_button.grab_focus()

func _on_language_dropdown_mouse_entered():
	language_dropdown.grab_focus()

func _on_window_mode_dropdown_mouse_entered():
	window_mode_dropdown.grab_focus()

func _on_window_resolution_dropdown_mouse_entered():
	window_resolution_dropdown.grab_focus()

func _on_monitor_dropdown_mouse_entered():
	monitor_dropdown.grab_focus()
