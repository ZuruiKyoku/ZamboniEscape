extends CPUParticles2D

@onready var catch_fire = $CatchFire

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_area_2d_body_entered(body):
	if body.name == "Enemy":
		if GameManager.enemyOnFire == false:
			catch_fire.play()
			body.startFire()


func _on_finished():
	queue_free()
