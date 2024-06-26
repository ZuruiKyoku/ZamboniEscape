extends CharacterBody2D

@onready var zamline:CPUParticles2D = $Zamline
@onready var player = %Player
@onready var red_zamline = $RedZamline
@onready var spawn_collider = $"../SpawnArea/SpawnCollider".shape.extents
@onready var trail = $Node2D/Trail2D
@onready var fire_tick = $FireTick
@onready var flames = $Flames

var moveToPos = Vector2(0,25)

var motion = Vector2.ZERO
var tween = null
var tweening:bool = false
var fireTicks:int = 0
var maxFireTicks:int = 5

func _ready():
	trail.self_modulate = Color8(0,148,255)

func _physics_process(_delta):
	if GameManager.currentState == GameManager.GameState.Playing:
		if (GameManager.enemyJustHit || GameManager.enemyJustHitGold) && !tweening:
			spin_zam()
		elif tweening:
			pass
		else:
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
				
func spin_zam(time = 2):
	if GameManager.enemyJustHitGold:
		time = 4
	tweening = true
	tween = create_tween()
	tween.tween_property(self, "rotation", time*TAU, time).as_relative()
	await tween.finished
	if GameManager.enemyJustHit:
		GameManager.enemyJustHit = false
	if GameManager.enemyJustHitGold:
		GameManager.enemyJustHitGold = false
	tweening = false
	
func startFire():
	GameManager.enemyOnFire = true
	Globals.user_prefs["TimesZamboniHitFlameTrails"] = Globals.user_prefs.increaseValue(Globals.user_prefs["TimesZamboniHitFlameTrails"])
	flames.emitting = true
	fire_tick.start(1)


func _on_near_miss_zone_body_exited(body):
	if body == player:
		#check if player just took damage, otherwise increase near miss
		pass


func _on_fire_tick_timeout():
	fireTicks += 1
	spin_zam(1)
	if fireTicks == maxFireTicks:
		GameManager.enemyOnFire = false
		flames.emitting = false
	else:
		fire_tick.start(3)
