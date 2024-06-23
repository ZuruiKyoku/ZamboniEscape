class_name TeamSelect extends CanvasLayer

@onready var player_name = %PlayerName
@onready var selected_team = %SelectedTeam
@onready var animation_player = $AnimationPlayer
@onready var team_container = %TeamContainer

var startPos = Vector2(35,133)
var posIncreaseBase = Vector2(69,55)
var selectedTeam = 0
var lastTeam = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	GameManager.currentState = GameManager.GameState.TeamSelect
	if Globals.user_prefs.playerName != "":
		player_name.text = Globals.user_prefs.playerName
	selectedTeam = Globals.user_prefs.playerTeam
	
	if player_name:
		player_name.text = Globals.user_prefs.playerName
	
	selectedTeam = Globals.user_prefs.playerTeam
	
	for t in team_container.get_child_count():
		var _tNode = ("Team" + str(t + 1))
		team_container.get_node(_tNode).button_up.connect(handle_team_select.bind(_tNode))
	
	animation_player.play("Spring_In")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if selectedTeam != lastTeam:
		updateSelectedPos()

func _on_main_menu_button_up():
	Globals.user_prefs.playerName = player_name.text
	Globals.user_prefs.playerTeam = selectedTeam
	GameManager.currentState = GameManager.GameState.GotoMain
	animation_player.play("Spring_Out")
	await animation_player.animation_finished
	queue_free()
	
func updateSelectedPos():
	lastTeam = selectedTeam
	var tempTeam:float = lastTeam
	var xMult:float = floor(selectedTeam % 8)
	var yMult:float = floor(tempTeam / 8)
	var tempIncrease = Vector2(posIncreaseBase.x * xMult, posIncreaseBase.y * yMult)
	selected_team.position = startPos + tempIncrease
	
func _notification(what):
	match what:
		NOTIFICATION_ENTER_TREE:
			get_tree().paused = false
		NOTIFICATION_EXIT_TREE:
			Globals.user_prefs.save()
			get_tree().paused = false
			

func handle_team_select(team):
	var teamVal:int = int(team.replace("Team", ""))
	teamVal -= 1
	selectedTeam = teamVal
	
