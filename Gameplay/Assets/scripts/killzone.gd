extends Area2D

@onready var crowd_cheer = $CrowdCheer
@onready var goal_horn = $GoalHorn

@onready var player_death_particles = $PlayerDeathParticles
@onready var enter_timer = $EnterTimer
@onready var exit_timer = $ExitTimer

var player = null

func _on_body_entered(body):
	player = body
	checkPlayer()
	
func _on_body_exited(_body):
	exit_timer.start(0.25)
	
func checkPlayer():
	if !GameManager.playerInvinc:
		GameManager.decreaseHealth()
		if GameManager.playerIsAlive == false:
			killPlayer()
		else:
			enter_timer.start(1)
	
func killPlayer():
	player.queue_free()
	player_death_particles.emitting = true
	Globals.user_prefs["Deaths"] = Globals.user_prefs.increaseValue(Globals.user_prefs["Deaths"])
	GameManager.playerIsAlive = false
	crowd_cheer.play()
	goal_horn.play()
	Globals.open_game_over()

	
func _on_enter_timer_timeout():
	GameManager.playerInvinc = false
	if player != null:
		checkPlayer()

func _on_exit_timer_timeout():
	player = null
