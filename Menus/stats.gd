class_name Stats extends CanvasLayer

@onready var animation_player = $AnimationPlayer
@onready var player_values = %PlayerValues
@onready var powerup_values = %PowerupValues
@onready var reset = %Reset


# Called when the node enters the scene tree for the first time.
func _ready():
	if Engine.is_editor_hint():
		reset.visible = false
	getValues()
	animation_player.play("Spring_In")

func getValues():
	#Player
	player_values.get_node("TimesPlayed").text = str(Globals.user_prefs.decryptValue(Globals.user_prefs["TimesPlayed"]))
	player_values.get_node("Deaths").text = str(Globals.user_prefs.decryptValue(Globals.user_prefs["Deaths"]))
	player_values.get_node("DistanceSkated").text = str(Globals.user_prefs.decryptValue(Globals.user_prefs["DistanceSkated"]))	
	player_values.get_node("PucksCollected").text = str(Globals.user_prefs.decryptValue(Globals.user_prefs["PucksCollected"]))
	player_values.get_node("PucksShot").text = str(Globals.user_prefs.decryptValue(Globals.user_prefs["PucksShot"]))
	player_values.get_node("PucksHit").text = str(Globals.user_prefs.decryptValue(Globals.user_prefs["PucksHit"]))
	player_values.get_node("GoalsMade").text = str(Globals.user_prefs.decryptValue(Globals.user_prefs["GoalsMade"]))
	player_values.get_node("GoalsMissed").text = str(Globals.user_prefs.decryptValue(Globals.user_prefs["GoalsMissed"]))
	player_values.get_node("NearMises").text = str(Globals.user_prefs.decryptValue(Globals.user_prefs["NearMisses"]))
	
	#Power-Ups
	powerup_values.get_node("TotalPowerUps").text = str(Globals.user_prefs.decryptValue(Globals.user_prefs["TotalPowerupsAcquired"]))
	powerup_values.get_node("GoldenAcquired").text = str(Globals.user_prefs.decryptValue(Globals.user_prefs["GoldenPucksAcquired"]))
	powerup_values.get_node("GoldenShot").text = str(Globals.user_prefs.decryptValue(Globals.user_prefs["GoldenPucksShot"]))
	powerup_values.get_node("GoldenHit").text = str(Globals.user_prefs.decryptValue(Globals.user_prefs["GoldenPucksHit"]))
	powerup_values.get_node("FlamesAcquired").text = str(Globals.user_prefs.decryptValue(Globals.user_prefs["FlameTrailsAcquired"]))
	powerup_values.get_node("FlamesUsed").text = str(Globals.user_prefs.decryptValue(Globals.user_prefs["FlameTrailsUsed"]))
	powerup_values.get_node("FlamesHit").text = str(Globals.user_prefs.decryptValue(Globals.user_prefs["TimesZamboniHitFlameTrails"]))
	powerup_values.get_node("SpeedAcquired").text = str(Globals.user_prefs.decryptValue(Globals.user_prefs["SpeedBoostsAcquired"]))
	powerup_values.get_node("SpeedUsed").text = str(Globals.user_prefs.decryptValue(Globals.user_prefs["SpeedBoostsUsed"]))
	powerup_values.get_node("ExtraLives").text = str(Globals.user_prefs.decryptValue(Globals.user_prefs["ExtraLivesAcquired"]))

func _on_close_button_up():
	GameManager.currentState = GameManager.GameState.GotoMain
	animation_player.play("Spring_Out")
	await animation_player.animation_finished
	queue_free()


func _on_reset_button_up():
	Globals.user_prefs.resetStats()
	getValues()
