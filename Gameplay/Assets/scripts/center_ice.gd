extends Node2D

@onready var left = $Left
@onready var right = $Right
@onready var background = $Background

var lastTeam = Globals.user_prefs.playerTeam

# Called when the node enters the scene tree for the first time.
func _ready():
	modulateColors()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if lastTeam != Globals.user_prefs.playerTeam:
		modulateColors()
		

func modulateColors():
	lastTeam = Globals.user_prefs.playerTeam
	if Colors.mainColor.size() > lastTeam:
		left.modulate = Colors.mainColor[lastTeam]
	
	if Colors.secondaryColor.size() > lastTeam:
		right.modulate = Colors.secondaryColor[lastTeam]
		
	if Colors.tertiaryColor.size() > lastTeam && Colors.tertiaryColor[lastTeam] != Color8(255,255,255) && Colors.mainColor[lastTeam] != Colors.tertiaryColor[lastTeam] && Colors.secondaryColor[lastTeam] != Colors.tertiaryColor[lastTeam]:
		background.modulate = Colors.tertiaryColor[lastTeam]
	else:
		background.modulate = Color8(0,0,0)
