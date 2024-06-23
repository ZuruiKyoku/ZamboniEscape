extends HBoxContainer

@onready var rank = %Rank
@onready var player_name = %PlayerName
@onready var score = %Score

func setVals(rankVal, nameVal, scoreVal):
	rank.text = rankVal
	player_name.text = nameVal
	score.text = scoreVal
