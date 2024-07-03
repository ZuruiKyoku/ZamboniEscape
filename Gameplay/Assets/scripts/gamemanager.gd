extends Node

#Player Vals
var playerScore:int = encryptValue(0)
var playerPuckCount:int = encryptValue(0)
var playerHealth:int = encryptValue(3)
var playerMaxHealth:int = encryptValue(5)
var playerGoals:int = encryptValue(0)
var playerComboVal:int = encryptValue(0)
var playerInvinc:bool = false
var playerIsAlive:bool = false
var givePowerup:bool = false
var hasSpeedBoost:bool = false
var hasGoldenPuck:bool = false
var hasFireTrail:bool = false
var fireTrailActive:bool = false

#Enemy Vals
var enemySpeed:float = 1.0
var lastEnemySpeed:float = 1.0
var canIncreaseEnemySpeed:bool = true
var enemyHitCount:int = 0
var enemyJustHit:bool = false
var enemyJustHitGold:bool = false
var enemyOnFire:bool = false

enum GameState {MainMenu, TeamSelect, Playing, Paused, GameOver, GotoMain, GotoPlay, GotoGameOver, Quit}
var currentState:GameState = GameState.MainMenu

func restart(state:GameState):
	#Reset Player
	currentState = state
	playerScore = encryptValue(0)
	playerPuckCount = encryptValue(0)
	playerHealth = encryptValue(3)
	playerGoals = encryptValue(0)
	playerComboVal = encryptValue(0)
	playerInvinc = false
	playerIsAlive = true
	givePowerup = false
	hasSpeedBoost = false
	hasGoldenPuck = false
	hasFireTrail = false
	fireTrailActive = false
	
	#Reset Enemy
	enemySpeed = 1.0
	lastEnemySpeed = 1.0
	canIncreaseEnemySpeed = true
	enemyHitCount = 0
	enemyJustHit = false
	enemyJustHitGold = false

func encryptValue(val):
	return ((val + 25) * 69)

func decryptValue(val):
	return ((val / 69) - 25)
	
func increaseScore():
	#increase by 50
	var tempScore = decryptValue(playerScore)
	tempScore += 50
	playerScore = encryptValue(tempScore)
	
func increasePucks():
	var tempPucks = decryptValue(playerPuckCount)
	tempPucks += 1
	playerPuckCount = encryptValue(tempPucks)
	
func decreasePucks():
	var tempPucks = decryptValue(playerPuckCount)
	tempPucks -= 1
	playerPuckCount = encryptValue(tempPucks)

func increaseHealth():
	var tempHealth = decryptValue(playerHealth)
	if tempHealth <= decryptValue(playerMaxHealth):
		tempHealth += 1
		playerHealth = encryptValue(tempHealth)

func decreaseHealth():
	playerInvinc = true
	var tempHealth = decryptValue(playerHealth)
	tempHealth -= 1
	if tempHealth < 1:
		playerIsAlive = false
	playerHealth = encryptValue(tempHealth)

func increaseGoals():
	var tempGoals = decryptValue(playerGoals)
	tempGoals += 1
	if tempGoals % 5 == 0:
		givePowerup = true
	playerGoals = encryptValue(tempGoals)
