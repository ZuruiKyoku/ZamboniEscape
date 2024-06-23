extends Control

func _on_timer_timeout():
	SceneManager.swap_scenes(SceneRegistry.main_scenes["StartScreen"],get_tree().root,self,"fade_to_black")
