extends Node

onready var turn = "PlayerOne"	#start the game on the first player's turn

onready var locationDocks = []	#location docks are numbered 1-9 from bottom left to top right
#don't keep stuff other than references, manip values in the docks to check/edit things


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
	#this func will eventually become "end turn"
	if player == "PlayerOne":
		
		#set all location docks to hidden mode
		for x in range(len(locationDocks)):
			locationDocks[x].SetLocationDockToHidden()
			
		
		
		
		var playerOneCards = GetPlayerOneUnusedCards()
		var locationCards = playerOneCards[0]
		var monsterCards = playerOneCards[1]
		var battleCards = playerOneCards[2]
		var strategyCards = playerOneCards[3]
		
		for x in range(len(locationCards)):
			#max is exclusive
			if locationCards[x].GetIsDocked() == true:
				#don't hide it, I'll make all location docks go into card back mode elsewhere
				pass
			else:
				#it's just in the card dock or unused, hide
				locationCards[x].hide()
				locationCards[x].set_process(false)
				locationCards[x].set_physics_process(false)
				locationCards[x].set_process_input(false)
		
		for x in range(len(monsterCards)):
			#max  is exclusive
			#there will be a special check for monster cards, but not right now
			monsterCards[x].hide()
			monsterCards[x].set_process(false)
			monsterCards[x].set_physics_process(false)
			monsterCards[x].set_process_input(false)
			
			
		for x in range(len(battleCards)):
			battleCards[x].hide()
			battleCards[x].set_process(false)
			battleCards[x].set_physics_process(false)
			battleCards[x].set_process_input(false)
			
		for x in range(len(strategyCards)):
			strategyCards[x].hide()
			strategyCards[x].set_process(false)
			strategyCards[x].set_physics_process(false)
			strategyCards[x].set_process_input(false)
			
		
			
			
	elif player == "PlayerTwo":
		#set all location docks to hidden mode
		for x in range(len(locationDocks)):
			locationDocks[x].SetLocationDockToHidden()
		
		var playerTwoCards = GetPlayerTwoUnusedCards()
		var locationCards = playerTwoCards[0]
		var monsterCards = playerTwoCards[1]
		var battleCards = playerTwoCards[2]
		var strategyCards = playerTwoCards[3]
		
		for x in range(len(locationCards)):
			#max is exclusive
			if locationCards[x].GetIsDocked() == true:
				#don't hide it, I'll make all location docks go into card back mode elsewhere
				pass
			else:
				#it's just in the card dock or unused, hide
				locationCards[x].hide()
				locationCards[x].set_process(false)
				locationCards[x].set_physics_process(false)
				locationCards[x].set_process_input(false)
		
		for x in range(len(monsterCards)):
			#max  is exclusive
			#there will be a special check for monster cards, but not right now
			monsterCards[x].hide()
			monsterCards[x].set_process(false)
			monsterCards[x].set_physics_process(false)
			monsterCards[x].set_process_input(false)
			
			
		for x in range(len(battleCards)):
			battleCards[x].hide()
			battleCards[x].set_process(false)
			battleCards[x].set_physics_process(false)
			battleCards[x].set_process_input(false)
			
		for x in range(len(strategyCards)):
			strategyCards[x].hide()
			strategyCards[x].set_process(false)
			strategyCards[x].set_physics_process(false)
			strategyCards[x].set_process_input(false)
	
func SetLocationDocks(listOfLocationDocks):
	locationDocks = listOfLocationDocks
	
	
	
	
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
