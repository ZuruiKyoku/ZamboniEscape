class_name UserPrefs extends Resource

@export_range(0,1,.05) var master_volume: float = 1.0
@export_range(0,1,.05) var music_volume: float = 1.0
@export_range(0,1,.05) var sfx_volume: float = 1.0
@export var use_smooth_movement:bool = true
@export var language:int = 0
@export var window_mode:int = 0
@export var window_resolution: Vector2i = Vector2i(960, 540)
@export var window_monitor: int = 0
@export var highscores:Dictionary

#Player Info
@export var playerName: String = ""
@export var playerTeam: int = 0

#region Player
@export var TimesPlayed:int = encryptValue(0)
@export var Deaths:int = encryptValue(0)
@export var DistanceSkated:float = encryptValue(0.0)
@export var PucksCollected:int = encryptValue(0)
@export var PucksShot:int = encryptValue(0)
@export var PucksHit:int = encryptValue(0)
@export var GoalsMade:int = encryptValue(0)
@export var GoalsMissed:int = encryptValue(0)
@export var NearMisses:int = encryptValue(0)
#endregion
	
#region Power-Ups
@export var TotalPowerupsAcquired:int = encryptValue(0)
@export var GoldenPucksAcquired:int = encryptValue(0)
@export var GoldenPucksShot:int = encryptValue(0)
@export var GoldenPucksHit:int = encryptValue(0)
@export var FlameTrailsAcquired:int = encryptValue(0)
@export var FlameTrailsUsed:int = encryptValue(0)
@export var TimesZamboniHitFlameTrails:int = encryptValue(0)
@export var SpeedBoostsAcquired:int = encryptValue(0)
@export var SpeedBoostsUsed:int = encryptValue(0)
#endregion

const USER_PREFS_PATH:String = "user://user_prefs.tres"

func save() -> void:
	ResourceSaver.save(self, USER_PREFS_PATH)
	
static func load_or_create() -> UserPrefs:
	var res:UserPrefs
	if FileAccess.file_exists(USER_PREFS_PATH):
		res = load(USER_PREFS_PATH) as UserPrefs
	else:
		res = UserPrefs.new()
	return res
	
func encryptValue(val):
	return ((val + 25) * 69)
	
func decryptValue(val):
	return ((val / 69) - 25)

func increaseValue(val):
	var tempVal = decryptValue(val)
	tempVal += 1
	return encryptValue(tempVal)

func resetStats():
	TimesPlayed = encryptValue(0)
	Deaths = encryptValue(0)
	DistanceSkated = encryptValue(0.0)
	PucksCollected = encryptValue(0)
	PucksShot = encryptValue(0)
	PucksHit = encryptValue(0)
	GoalsMade = encryptValue(0)
	GoalsMissed = encryptValue(0)
	NearMisses = encryptValue(0)
	TotalPowerupsAcquired = encryptValue(0)
	GoldenPucksAcquired = encryptValue(0)
	GoldenPucksShot = encryptValue(0)
	GoldenPucksHit = encryptValue(0)
	FlameTrailsAcquired = encryptValue(0)
	FlameTrailsUsed = encryptValue(0)
	TimesZamboniHitFlameTrails = encryptValue(0)
	SpeedBoostsAcquired = encryptValue(0)
	SpeedBoostsUsed = encryptValue(0)
