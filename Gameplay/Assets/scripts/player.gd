extends CharacterBody2D

@onready var animated_sprite = $AnimatedSprite2D
@onready var collision_shape = $CollisionShape2D
@onready var skateline = $Skateline

const SPEED = 300.0
var lastH = 0
var lastV = 0
var lastHSpeed = 0
var lastVSpeed = 0

const BOOST = 100

func _ready():
	animated_sprite.frame = Globals.user_prefs.playerTeam

func _physics_process(_delta):
	if GameManager.currentState == GameManager.GameState.Playing:
		#Horizontal Movement
		var hDirection = Input.get_axis("move_left", "move_right")
		if hDirection:
			if Input.is_action_just_pressed("Boost") && GameManager.hasSpeedBoost:
				velocity.x = hDirection * SPEED * BOOST
				GameManager.hasSpeedBoost = false
			else:
				velocity.x = hDirection * SPEED
			lastH = hDirection
			lastHSpeed = SPEED
		else:
			lastHSpeed *= 0.95
			velocity.x = lastH * lastHSpeed	
		
		#Vertical Movement
		var vDirection = Input.get_axis("move_up", "move_down")
		if vDirection:
			if Input.is_action_just_pressed("Boost") && GameManager.hasSpeedBoost:
				velocity.y = vDirection * SPEED * BOOST
				GameManager.hasSpeedBoost = false
				Globals.user_prefs["SpeedBoostsUsed"] = Globals.user_prefs.increaseValue(Globals.user_prefs["SpeedBoostsUsed"])
			else:
				velocity.y = vDirection * SPEED
			lastV = vDirection
			lastVSpeed = SPEED
		else:
			lastVSpeed *= 0.95
			velocity.y = lastV * lastVSpeed	
			
		animated_sprite.look_at(get_global_mouse_position())
		collision_shape.look_at(get_global_mouse_position())
		
		#fix velocity never getting back to 0
		if velocity.x != 0 || velocity.y != 0:
			if velocity.x <= 5 && velocity.x >= -5:
				velocity.x = 0
			if velocity.y <= 5 && velocity.y >= -5:
				velocity.y = 0
			skateline.emitting = true
		else:
			skateline.emitting = false
		
		
#Rotate Sprite
	#if(hDirection == 0):
	#	if(vDirection == -1):
	#		rotation_degrees = 270
	#	elif(vDirection == 1):
	#		rotation_degrees = 90
	#elif(vDirection == 0):
	#	if(hDirection == -1):
	#		rotation_degrees = 180
	#	elif(hDirection == 1):
	#		rotation_degrees = 0
	#elif(hDirection == -1 && vDirection == -1):
	#	rotation_degrees = 225
	#elif(hDirection == -1 && vDirection == 1):
	#	rotation_degrees = 135
	#elif(hDirection == 1 && vDirection == -1):
	#	rotation_degrees = 315
	#elif(hDirection == 1 && vDirection == 1):
	#	rotation_degrees = 45
	
	move_and_slide()
