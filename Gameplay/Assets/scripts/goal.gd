extends Node2D


func _on_miss_body_exited(body):
	Globals.user_prefs["GoalsMissed"] = Globals.user_prefs.increaseValue(Globals.user_prefs["GoalsMissed"])
	print("Missed")


func _on_goal_line_body_exited(body):
	if body.name.contains("Puck"):
		body.queue_free()
		GameManager.increaseGoals()
		Globals.user_prefs["GoalsMade"] = Globals.user_prefs.increaseValue(Globals.user_prefs["GoalsMade"])
		print("goal")
