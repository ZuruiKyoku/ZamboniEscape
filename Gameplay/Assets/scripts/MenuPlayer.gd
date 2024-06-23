extends Area2D

@onready var path_follow:PathFollow2D = get_parent()
@onready var player_sprite = %PlayerSprite
@onready var trail = $"../../MenuEnemy/MenuEnemyObj/Node2D/Trail2D"


@export var speed = 300

func _ready():
	if player_sprite:
		player_sprite.frame = Globals.user_prefs.playerTeam
	
	trail.self_modulate = Color8(0,148,255)

func _physics_process(delta):
	if player_sprite:
		if player_sprite.frame != Globals.user_prefs.playerTeam:
			player_sprite.frame = Globals.user_prefs.playerTeam
	path_follow.set_progress(path_follow.get_progress() + (speed * delta))
