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

onready var playerOneUnusedStrategyCards = []
onready var playerOneUsedStrategyCards = []

#player two cards
onready var playerTwoUnusedMonsterCards = []
onready var playerTwoUsedMonsterCards = []

onready var playerTwoUnusedLocationCards = []
onready var playerTwoUsedLocationCards = []

onready var playerTwoUnusedBattleCards = []
onready var playerTwoUsedBattleCards = []

onready var playerTwoUnusedStrategyCards = []
onready var playerTwoUsedStrategyCards = []


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

func ClearPlayerCards(player):
	if player == "PlayerOne":
		var playerOneCards = GetPlayerOneUnusedCards()
		
		for x in range(len(playerOneCards)):
			#4 is how many types of cards there are, max is exclusive
			for y in range(len(playerOneCards[x])):
				#that's how many cards of each type there could be, max is exclusive
				playerOneCards[x][y].hide()
				playerOneCards[x][y].set_process(false)
				playerOneCards[x][y].set_physics_process(false)
				playerOneCards[x][y].set_process_input(false)
				
	else:
		
		var playerTwoCards = GetPlayerTwoUnusedCards()
		
		for x in range(len(playerTwoCards)):
			#4 is how many types of cards there are, max is exclusive
			for y in range(len(playerTwoCards[x])):
				#that's how many cards of each type there could be, max is exclusive
				playerTwoCards[x][y].hide()
				playerTwoCards[x][y].set_process(false)
				playerTwoCards[x][y].set_physics_process(false)
				playerTwoCards[x][y].set_process_input(false)
	
func AddLocationDock(newLocationDock):
	locationDocks.append(newLocationDock)
	
#add cards for player one
func AddPlayerOneLocationCard(newLocationCard):
	playerOneUnusedLocationCards.append(newLocationCard)
	
func AddPlayerOneMonsterCard(newMonsterCard):
	playerOneUnusedMonsterCards.append(newMonsterCard)
	
func AddPlayerOneBattleCard(newBattleCard):
	playerOneUnusedBattleCards.append(newBattleCard)
	
func AddPlayerOneStrategyCard(newStrategyCard):
	playerOneUnusedStrategyCards.append(newStrategyCard)
	
	
func GetPlayerOneUnusedCards():
	return [playerOneUnusedLocationCards, playerOneUnusedMonsterCards, playerOneUnusedBattleCards, playerOneUnusedStrategyCards]
	
func GetPlayerTwoUnusedCards():
	return [playerTwoUnusedLocationCards, playerTwoUnusedMonsterCards, playerTwoUnusedBattleCards, playerTwoUnusedStrategyCards]
	
	
#add cards for player two
func AddPlayerTwoLocationCard(newLocationCard):
	playerTwoUnusedLocationCards.append(newLocationCard)
	
func AddPlayerTwoMonsterCard(newMonsterCard):
	playerTwoUnusedMonsterCards.append(newMonsterCard)
	
func AddPlayerTwoBattleCard(newBattleCard):
	playerTwoUnusedBattleCards.append(newBattleCard)
	
func AddPlayerTwoStrategyCard(newStrategyCard):
	playerTwoUnusedStrategyCards.append(newStrategyCard)
