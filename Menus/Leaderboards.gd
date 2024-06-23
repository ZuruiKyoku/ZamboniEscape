class_name Leaderboards extends CanvasLayer

@onready var score_continer = %ScoreContiner
@onready var loading = $Loading
@onready var animation_player = $AnimationPlayer

const LEADERBOARD_ENTRY = preload("res://Menus/leaderboard_entry.tscn")

var sw_result: Dictionary

func _ready():
	animation_player.play("Spring_In")

func get_scores():
	loading.visible = true
	clear_scores()
	sw_result = await SilentWolf.Scores.get_scores().sw_get_scores_complete
	
	for i in sw_result["scores"].size():
		var newEntry = LEADERBOARD_ENTRY.instantiate()
		score_continer.add_child(newEntry)
		newEntry.setVals(str(i+1), str(sw_result["scores"][i]["player_name"]), str(sw_result["scores"][i]["score"]))
		newEntry.name = "LEADERBOARD_ENTRY " + str(sw_result["scores"][i]["player_name"])
	
	loading.visible = false

func clear_scores():
	var children = score_continer.get_children()
	for c in children:
		if c.name.contains("LEADERBOARD_ENTRY"):
			score_continer.remove_child(c)
			c.queue_free()

func _on_main_menu_button_up():
	animation_player.play("Spring_Out")
	
func _on_refresh_button_up():
	get_scores()


func _on_animation_player_animation_finished(anim_name):
	if anim_name == "Spring_In":
		get_scores()
	elif anim_name == "Spring_Out":
		queue_free()
