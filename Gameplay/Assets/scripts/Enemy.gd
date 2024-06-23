extends CharacterBody2D

@onready var zamline:CPUParticles2D = $Zamline
@onready var player = %Player
@onready var red_zamline = $RedZamline
@onready var spawn_collider = $"../SpawnArea/SpawnCollider".shape.extents
@onready var trail = $Node2D/Trail2D

var moveToPos = Vector2(0,25)

var motion = Vector2.ZERO

func _ready():
	trail.self_modulate = Color8(0,148,255)

func _physics_process(_delta):
	if GameManager.currentState == GameManager.GameState.Playing:
		motion = Vector2.ZERO
		if player != null:
			look_at(player.global_position)
			position = position.move_toward(player.position, GameManager.enemySpeed)
		else:
			zamline.texture = red_zamline.texture
			trail.self_modulate = Color8(171,0,0)
			look_at(moveToPos)
			position = position.move_toward(moveToPos, GameManager.enemySpeed)
		
		move_and_slide()
		
		if GameManager.canIncreaseEnemySpeed && GameManager.enemySpeed < 5:
			GameManager.enemySpeed += 0.005
		
		if moveToPos == position:
			var x = randf_range((0 - spawn_collider.x), spawn_collider.x)
			var y = randf_range((0 - spawn_collider.y), spawn_collider.y)
			moveToPos = Vector2(x,y)
