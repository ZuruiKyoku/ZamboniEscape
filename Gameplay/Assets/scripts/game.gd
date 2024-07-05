extends Node2D

const POWERUP = preload("res://Gameplay/Assets/scenes/powerup.tscn")
var PUCK = preload("res://Gameplay/Assets/scenes/puck.tscn")
var PICKUPPUCK = preload("res://Gameplay/Assets/scenes/pickup_puck.tscn")
var shotPart = preload("res://Gameplay/Assets/scenes/shot_part.tscn")

@onready var player = %Player
@onready var enemy = %Enemy
@onready var puck_count_label = %PuckCountLabel
@onready var score_label = %ScoreLabel
@onready var increase_score = $IncreaseScore
@onready var spawn_collider = $SpawnArea/SpawnCollider.shape.extents
@onready var puck_spawner = $PuckSpawner
@onready var shoot = $Shoot
@onready var life_container = %LifeContainer
@onready var animation_player:AnimationPlayer = $AnimationPlayer
@onready var puck_container = $PuckContainer
@onready var speed_boost = $SpeedBoost
@onready var gold_puck = $GoldPuck
@onready var fire_trail = $FireTrail
@onready var fire_trail_timer = $FireTrailTimer
@onready var catch_fire = $CatchFire

# Called when the node enters the scene tree for the first time.
func _ready():
	GameManager.restart(GameManager.GameState.Playing)
	updateHealthBar()
	get_tree().paused = true

func start_scene():
	animation_player.play("GameStart")
	await animation_player.animation_finished
	get_tree().paused = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if GameManager.currentState == GameManager.GameState.Quit:
		SceneManager.swap_scenes(SceneRegistry.main_scenes["Quit"],get_tree().root,self,"quit_to")
		
	else:
		if Input.is_action_just_pressed("Shoot") && GameManager.decryptValue(GameManager.playerPuckCount) > 0 && GameManager.playerIsAlive:
			shootPuck()
			
		if Input.is_action_just_pressed("ShootGolden") && GameManager.hasGoldenPuck && GameManager.playerIsAlive:
			shootGold()
		
		if Input.is_action_just_pressed("FireTrail") && GameManager.hasFireTrail && GameManager.playerIsAlive:
			startFire()
			
		puck_count_label.text = "Pucks: " + str(ceil(GameManager.decryptValue(GameManager.playerPuckCount)))
		score_label.text = "Score: " + str(GameManager.decryptValue(GameManager.playerScore))
		
		updateHealthBar()
		
		#Powerups
		if GameManager.givePowerup:
			givePowerup()
			
		if !GameManager.hasSpeedBoost:
			speed_boost.visible = false
		
		if Input.is_action_just_pressed("pause") && GameManager.playerIsAlive:
			Globals.open_settings_menu()
			
		if GameManager.currentState == GameManager.GameState.GotoMain:
			goto_main_menu()
			
		if GameManager.currentState == GameManager.GameState.GotoPlay:
			goto_restart()

func _on_increase_score_timeout():
	if GameManager.playerIsAlive:
		GameManager.increaseScore()
		increase_score.start(1)
		
func shootPuck():
	var puck = PUCK.instantiate()
	puck.shoot()
	puck.name = "Puck" + str(randf())
	puck.position = player.position
	puck.rotation_degrees = player.get_node("AnimatedSprite2D").rotation_degrees
	var part = shotPart.instantiate()
	part.modulate = Color8(0,228,229)
	part.position = player.position
	part.rotation_degrees = player.get_node("AnimatedSprite2D").rotation_degrees
	shoot.play()
	puck_container.add_child((puck))
	puck_container.add_child(part)
	Globals.user_prefs["PucksShot"] = Globals.user_prefs.increaseValue(Globals.user_prefs["PucksShot"])
	
func shootGold():
	var puck = PUCK.instantiate()
	puck.shootGold()
	puck.name = "GoldPuck" + str(randf())
	puck.position = player.position
	puck.rotation_degrees = player.get_node("AnimatedSprite2D").rotation_degrees
	var part = shotPart.instantiate()
	part.modulate = Color8(218,165, 32)
	part.position = player.position
	part.rotation_degrees = player.get_node("AnimatedSprite2D").rotation_degrees
	shoot.play()
	puck_container.add_child((puck))
	puck_container.add_child(part)
	Globals.user_prefs["GoldenPucksShot"] = Globals.user_prefs.increaseValue(Globals.user_prefs["GoldenPucksShot"])
	gold_puck.visible = false
	
func startFire():
	catch_fire.play()
	GameManager.hasFireTrail = false
	GameManager.fireTrailActive = true
	fire_trail.visible = false
	fire_trail_timer.start(5)
	Globals.user_prefs["FlameTrailsUsed"] = Globals.user_prefs.increaseValue(Globals.user_prefs["FlameTrailsUsed"])

func _on_puck_spawner_timeout():
	if(GameManager.playerIsAlive):
		var x = randf_range((0 - spawn_collider.x) , spawn_collider.x)
		var y = randf_range((0 - spawn_collider.y), spawn_collider.y)
		var pickUpPuck = PICKUPPUCK.instantiate()
		pickUpPuck.position = Vector2(x,y)
		pickUpPuck.player = player
		add_child(pickUpPuck)
		puck_spawner.start(5)

func updateHealthBar():
	var tempHealth = GameManager.decryptValue(GameManager.playerHealth)
	
	for r in tempHealth:
		var _rNode = ("HP" + str(r + 1))
		life_container.get_node(_rNode).self_modulate = Color.DARK_RED
	
	for w in range(tempHealth, 5):
		var _wNode = ("HP" + str(w + 1))
		life_container.get_node(_wNode).self_modulate = Color.WHITE

func givePowerup():
	var tmp_PU = POWERUP.instantiate()
	GameManager.givePowerup = false
	var values = []
	
	if GameManager.decryptValue(GameManager.playerHealth) < 5:
		values.append("Health")
	if !GameManager.hasSpeedBoost:
		values.append("Boost")
	if !GameManager.hasGoldenPuck:
		values.append("Gold")
	if !GameManager.hasFireTrail:
		values.append("Fire")
	
	if values.size() > 0:
		var selectedValue = values.pick_random()
		match selectedValue:
			"Health":
				GameManager.increaseHealth()
				Globals.user_prefs["ExtraLivesAcquired"] = Globals.user_prefs.increaseValue(Globals.user_prefs["ExtraLivesAcquired"])
			"Boost":
				GameManager.hasSpeedBoost = true
				speed_boost.visible = true
				Globals.user_prefs["SpeedBoostsAcquired"] = Globals.user_prefs.increaseValue(Globals.user_prefs["SpeedBoostsAcquired"])
			"Gold":
				GameManager.hasGoldenPuck = true
				gold_puck.visible = true
				Globals.user_prefs["GoldenPucksAcquired"] = Globals.user_prefs.increaseValue(Globals.user_prefs["GoldenPucksAcquired"])
			"Fire":
				GameManager.hasFireTrail = true
				fire_trail.visible = true
				Globals.user_prefs["FlameTrailsAcquired"] = Globals.user_prefs.increaseValue(Globals.user_prefs["FlameTrailsAcquired"])
		
		Globals.user_prefs["TotalPowerupsAcquired"] = Globals.user_prefs.increaseValue(Globals.user_prefs["TotalPowerupsAcquired"])
		tmp_PU.SetPowerup(selectedValue)
		player.add_child(tmp_PU)
	else:
		GameManager.increaseScore()
		GameManager.increaseScore()

func goto_main_menu():
	GameManager.currentState = GameManager.GameState.MainMenu
	SceneManager.swap_scenes(SceneRegistry.main_scenes["StartScreen"],get_tree().root,self,"zamboni_to_left")

func goto_restart():
	GameManager.currentState = GameManager.GameState.Playing
	SceneManager.swap_scenes(SceneRegistry.levels["game_start"],get_tree().root,self,"zamboni_to_right")

func _on_fire_trail_timer_timeout():
	GameManager.fireTrailActive = false
