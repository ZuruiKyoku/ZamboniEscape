extends Node2D

var pucksMade = []

func _on_miss_body_exited(body):
	if body.name.contains("Puck") && pucksMade.find(body.name) == -1:
		Globals.user_prefs["GoalsMissed"] = Globals.user_prefs.increaseValue(Globals.user_prefs["GoalsMissed"])


func _on_goal_line_body_exited(body):
	if body.name.contains("Puck"):
		pucksMade.append(body.name)
		body.queue_free()
		GameManager.increaseGoals()
		Globals.user_prefs["GoalsMade"] = Globals.user_prefs.increaseValue(Globals.user_prefs["GoalsMade"])
