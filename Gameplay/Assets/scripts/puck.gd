extends RigidBody2D

@onready var animation_player = $AnimationPlayer
@onready var timer = $Timer

var playerScript = preload("res://Gameplay/Assets/scripts/player.gd")
var enemyScript = preload("res://Gameplay/Assets/scripts/Enemy.gd")

@onready var sprite = $Sprite2D
@onready var bounce = $Bounce
@onready var gold_parts = $GoldParts
@onready var trail = $Sprite2D/Trail2D

var movePos = Vector2(0,0)
var speed = 300
var direction = Vector2(0,0)
var isGolden = false

var hitEnemy = false

func _ready():	
	direction  = (get_global_mouse_position() - position).normalized()
	
	if isGolden:
		gold_parts.emitting = true
		sprite.modulate = Color8(218,165, 32)
		timer.start(5)
	else:
		sprite.self_modulate = Color8(34,34,34)
		trail.modulate = Color8(0,228,229)
	
func shoot():
	GameManager.decreasePucks()

func shootGold():
	GameManager.hasGoldenPuck = false
	isGolden = true
	speed = 500
	scale = Vector2(2,2)
	
func _physics_process(delta):	
	var collisionInfo = move_and_collide(speed*delta*direction)
	if collisionInfo:
		var collider = collisionInfo.get_collider()
		if collider.name == "Enemy":
			hitEnemy = true
			if isGolden:
				if GameManager.enemyJustHitGold == false && GameManager.enemyJustHit == false:
					GameManager.enemyJustHitGold = true
				Globals.user_prefs["GoldenPucksHit"] = Globals.user_prefs.increaseValue(Globals.user_prefs["GoldenPucksHit"])
				animation_player.play("HitEnemyGold")
			else:
				if GameManager.enemyJustHit == false && GameManager.enemyJustHitGold == false:
					GameManager.enemyJustHit = true
				Globals.user_prefs["PucksHit"] = Globals.user_prefs.increaseValue(Globals.user_prefs["PucksHit"])
				animation_player.play("HitEnemy")
			GameManager.enemyHitCount += 1
			GameManager.canIncreaseEnemySpeed = false
			if GameManager.enemySpeed != 0:
				GameManager.lastEnemySpeed = GameManager.enemySpeed
				GameManager.enemySpeed = 0
		else:
			direction = direction.bounce(collisionInfo.get_normal())
			bounce.play()


func _on_timer_timeout():
	if hitEnemy:
		GameManager.enemyHitCount -= 1
	if GameManager.enemyHitCount == 0:
		GameManager.enemySpeed = GameManager.lastEnemySpeed
		GameManager.canIncreaseEnemySpeed = true
	queue_free()

func _on_timer_2_timeout():
	animation_player.play("Shoot")
