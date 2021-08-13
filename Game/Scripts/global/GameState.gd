extends Node

onready var turn = "PlayerOne"	#start the game on the first player's turn

onready var locationDocks = []



#player one cards
onready var playerOneUnusedMonsterCards = []
onready var playerOneUsedMonsterCards = []

onready var playerOneUnusedLocationCards = []
onready var playerOneUsedLocationCards = []

onready var playerOneUnusedBattleCards = []
onready var playerOneUsedBattleCards = []

#player two cards
onready var playerTwoUnsedMonsterCards = []
onready var playerTwoUsedMonsterCards = []

onready var playerTwoUnusedLocationCards = []
onready var playerTwoUsedLocationCards = []

onready var playerTwoUnusedBattleCards = []
onready var playerTwoUsedBattleCards = []


func _ready():
	pass
	

func GetCurrentTurn():
	return turn

func ChangeCurrentTurn():
	#this is setup this way to prevent spelling mistakes from breaking the turn system
	if turn == "PlayerOne":
		turn = "PlayerTwo"
	else:
		turn = "PlayerOne"
	
	
func AddLocationDock(newLocationDock):
	locationDocks.append(newLocationDock)
	
func AddPlayerOneLocationCard(newLocationCard):
	playerOneUnusedLocationCards.append(newLocationCard)
	
func AddPlayerOneMonsterCard(newMonsterCard):
	#this code should also add the card to the card dock before setting the reference to it
	playerOneUnusedMonsterCards.append(newMonsterCard)
