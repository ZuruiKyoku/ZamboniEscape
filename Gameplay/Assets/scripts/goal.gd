extends Node2D

const SCORE = preload("res://Gameplay/Assets/scenes/score.tscn")
var pucksMade = []

func _on_miss_body_exited(body):
	if body.name.contains("Puck") && pucksMade.find(body.name) == -1:
		Globals.user_prefs["GoalsMissed"] = Globals.user_prefs.increaseValue(Globals.user_prefs["GoalsMissed"])


func _on_goal_line_body_exited(body):
	if body.name.contains("Puck"):
		var score = SCORE.instantiate()
		if name == "NetRight" || name == "NetLeft":
			score.SetSide(name)
			add_child(score)
		pucksMade.append(body.name)
		body.queue_free()
		GameManager.increaseGoals()
		Globals.user_prefs["GoalsMade"] = Globals.user_prefs.increaseValue(Globals.user_prefs["GoalsMade"])
