extends RigidBody2D

@onready var animation_player = $AnimationPlayer
@onready var timer = $Timer

var playerScript = preload("res://Gameplay/Assets/scripts/player.gd")
var enemyScript = preload("res://Gameplay/Assets/scripts/Enemy.gd")

@onready var bounce = $Bounce

var movePos = Vector2(0,0)
var speed = 300
var direction = Vector2(0,0)
var isGolden = false

var hitEnemy = false

func _ready(golden = false):
	if golden:
		GameManager.hasGoldenPuck = false
		isGolden = true
	else:
		GameManager.decreasePucks()
		direction  = (get_global_mouse_position() - position).normalized()
	
func _physics_process(delta):
	#position += speed*delta*direction
	
	var collisionInfo = move_and_collide(speed*delta*direction)
	if collisionInfo:
		var collider = collisionInfo.get_collider()
		if collider.name == "Enemy":
			hitEnemy = true
			if isGolden:
				Globals.user_prefs
			GameManager.enemyHitCount += 1
			animation_player.play("HitEnemy")
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
