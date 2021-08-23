extends Node

onready var turn = "PlayerOne"	#start the game on the first player's turn

onready var locationDocks = []	#location docks are numbered 1-9 from bottom left to top right
#don't keep stuff other than references, manip values in the docks to check/edit things

var thereIsACardBeingDragged = false

var sceneRoot = load("res://Game/Scripts/Experimental/Test root.gd")

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


var activeCardsList = []	#if a card is "active" then it filters monster attacks(based on it's priority)
var activeCardPriority = 1

var thereIsActiveBattle = false
var indexOfActiveLocationCardDock = -1	#-1 so it will error instead of silent fail if there's a problem
var playerBattleTurn = ""	#regular turns are seperate from battle turns, because battle turns aren't the same as regular turns and will go until the battle ends at which point the regular turns will resume
var playerWhoLandedlast = ""
var battleState = ""	#depending on the battle state the player's actions may be restricted. They can only select monster attacks in "monster attack" phase for instance





func GetThereIsACardBeingDragged():
	return thereIsACardBeingDragged

func SetThereIsACardBeingDragged(newValue):
	thereIsACardBeingDragged = newValue




func _ready():
	pass
	
func RegisterBattleStarted(index, lastPlayerToLand):
	thereIsActiveBattle = true
	indexOfActiveLocationCardDock = index
	playerWhoLandedlast = lastPlayerToLand
	#playerBattleTurn will be decided by the location card

func GetCurrentTurn():
	return turn

func ChangeCurrentTurn():
	#this is setup this way to prevent spelling mistakes from breaking the turn system
	if turn == "PlayerOne":
		turn = "PlayerTwo"
	else:
		turn = "PlayerOne"

func DoMonsterEffectAtCurrentBattleIndex(index, monsterAttack):
	var dock = locationDocks[index]
	return dock.UseMonsterCardEffect(monsterAttack)
	#returns monster attack
	

func DealDamageToOtherMonsterAtCurrentBattleIndex(index, monsterAttack):
	var dock = locationDocks[index]
	dock.DealDamageToMonster(monsterAttack)
	
func CheckForVictoryAtCurrentBattleIndex(index):
	var dock = locationDocks[index]
	return dock.GetVictory()
	

func AddCardToActiveCardList(card):
	#add the card and give it a priority, the more recent it is the higher the priority
	card.SetPriority(activeCardPriority)
	activeCardPriority += 1	
	activeCardsList.append(card)
	
func FilterMonsterCardAttacks(attacksToFilter):
	#for in range through active cards, call the filter func of that active thing
	var filteredAttacks = []
	for attack in attacksToFilter:
		for activeCard in activeCardsList:
			attack = activeCard.FilterAttack(attack)
			
		filteredAttacks.append(attack)
	return filteredAttacks
	#this function returns the list of attacks
	
func FilterBattleCard(battleCardToFilter):
	for activeCard in activeCardsList:
		battleCardToFilter = activeCard.BattleCardFilter(battleCardToFilter)
		
	return battleCardToFilter

#GameState.FilterMonsterData(dataToFilter)
func FilterMonsterData(dataToFilter):
	#[attribute, health]
	for activeCard in activeCardsList:
		dataToFilter = activeCard.MonsterDataFilter(dataToFilter)
		
	return dataToFilter


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
			if monsterCards[x].GetCardIsDocked() == true:
				#don't hide it, it's docked in a monster card dock waiting for a battle
				pass
			else:
				monsterCards[x].hide()
				monsterCards[x].set_process(false)
				monsterCards[x].set_physics_process(false)
				monsterCards[x].set_process_input(false)
			
			
		for x in range(len(battleCards)):
			if battleCards[x].GetCardInvolvedInBattle() == true:
				#it's a part of a battle, don't mess with it
				pass
			else:
				
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
			if monsterCards[x].GetCardIsDocked() == true:
				#don't hide it, it's docked in a monster card dock waiting for a battle
				pass
			else:
				monsterCards[x].hide()
				monsterCards[x].set_process(false)
				monsterCards[x].set_physics_process(false)
				monsterCards[x].set_process_input(false)
			
			
		for x in range(len(battleCards)):
			if battleCards[x].GetCardInvolvedInBattle() == true:
				#it's a part of a battle, don't mess with it
				pass
			else:
				
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
	
func GetBattleState():
	return battleState
	
func SetBattleState(newBattleState):
	battleState = newBattleState

func GetPlayerWhoLandedlast():
	return playerWhoLandedlast
	
func GetindexOfActiveLocationCardDock():
	return indexOfActiveLocationCardDock
	

func GetCenterOfLocationCardDockAtIndex(index):
	var dock = locationDocks[index]
	return dock.GetCenter()
	
	
func SetLocationCardAtIndexToHidden(index):
	#I need this function otherwise the shown location card will draw over
	#the attack selection dialogue, which looks terrible
	var dock = locationDocks[index]
	dock.SetLocationDockToHidden()
	
func SetLocationCardAtIndexToRevealed(index):
	#I need this function otherwise the shown location card will draw over
	#the attack selection dialogue, which looks terrible
	var dock = locationDocks[index]
	dock.SetLocationDockToRevealed()
	
	
func SetPlayerBattleTurn(playerTurn):
	playerBattleTurn = playerTurn
	
func GetPlayerBattleTurn():
	return playerBattleTurn
	
func ChangePlayerBattleTurn():
	if playerBattleTurn == "PlayerOne":
		playerBattleTurn = "PlayerTwo"
	else:
		playerBattleTurn = "PlayerOne"
	
func GetPlayerMonsterDataAtCurrentBattleIndex(player):
	#player is either "PlayerOne" or "PlayerTwo"
	var dock = locationDocks[GetindexOfActiveLocationCardDock()]
	return dock.GetPlayerMonsterData(player)
	
func StartBattle():
	
	#check the turns, swap over the turns if nessesary, in most cases it won't be
	if playerBattleTurn == turn:
		#if the playerBattleTurn is the same as the lastplayertoland/current turn then we don't need to change anything
		battleState = "MonsterAttackPhase"
	else:
		#this code won't work because of the sceneRoot, but that's another story for later
		
		#swap whose turn it is
		sceneRoot.get_node("Dock").ClearAll()	#wipe the data in card dock
	#in card dock, it seems the values from dicts and the actual values are not the same, this could/will be the source of future problems
		GameState.ClearPlayerCards(GameState.GetCurrentTurn())	#make the unused cards of playerone(the ones that would be in the dock) invisible and unusable
		GameState.ChangeCurrentTurn()
	
		if GameState.GetCurrentTurn() == "PlayerOne":
			sceneRoot.get_node("Dock").LoadPlayerCards(GameState.GetPlayerOneUnusedCards())
		else:
			sceneRoot.get_node("Dock").LoadPlayerCards(GameState.GetPlayerTwoUnusedCards())
	
	#[attribute, health]
	#filter the current player's monster that's involved in the battle!
	GameState.FilterMonsterData(GetPlayerMonsterDataAtCurrentBattleIndex(GameState.GetPlayerBattleTurn()))
	
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
