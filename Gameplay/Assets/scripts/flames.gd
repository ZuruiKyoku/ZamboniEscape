extends CPUParticles2D

@onready var catch_fire = $CatchFire

func _on_area_2d_body_entered(body):
	if body.name == "Enemy":
		if GameManager.enemyOnFire == false:
			catch_fire.play()
			body.startFire()


func _on_finished():
	queue_free()
