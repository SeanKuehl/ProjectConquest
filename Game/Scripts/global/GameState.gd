extends Node

onready var turn = "PlayerOne"	#start the game on the first player's turn

onready var locationDocks = []	#location docks are numbered 1-9 from bottom left to top right
#don't keep stuff other than references, manip values in the docks to check/edit things

var thereIsACardBeingDragged = false

var sceneRoot = load("res://Game/Scripts/Experimental/Test root.gd")

#player one stuff
var playerOnePoints = 0	#you get points by winning battles, if you win enough battles you win the game


#player one cards
onready var playerOneUnusedMonsterCards = []
onready var playerOneUsedMonsterCards = []

onready var playerOneUnusedLocationCards = []
onready var playerOneUsedLocationCards = []

onready var playerOneUnusedBattleCards = []
onready var playerOneUsedBattleCards = []

onready var playerOneUnusedStrategyCards = []
onready var playerOneUsedStrategyCards = []


#player two stuff
var playerTwoPoints = 0	#you get points by winning battles, if you win enough battles you win the game

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

var turnState = ""	#this can be "setup", "location card placement phase", "monster card phase" or "strategy card phase"

var strategyPreparationValues = []


func GetStrategyPreparationValues():
	return strategyPreparationValues
	
func SetStrategyPreparationValues(values):
	strategyPreparationValues = values

func GetTurnState():
	return turnState
	
func SetTurnState(newState):
	turnState = newState
	
func ChangeTurnState():
	
	var alreadyChanged = false
	
	if turnState == "Setup" and alreadyChanged == false:
		turnState = "LocationCardPhase"
		alreadyChanged = true
	if turnState == "LocationCardPhase" and alreadyChanged == false:
		turnState = "MonsterCardPhase"
		alreadyChanged = true
	if turnState == "MonsterCardPhase" and alreadyChanged == false:
		turnState = "StrategyCardPhase"
		alreadyChanged = true
	if turnState == "StrategyCardPhase" and alreadyChanged == false:
		turnState = "LocationCardPhase"	#setup only happens once at the start of the game
		alreadyChanged = true
		
	#sanity check to catch a possible typo with turnState
	#if it got here without using one of the ifs above and alreadyChanged is still false, send a print statement error message
	if alreadyChanged == false:
		print("ERROR: there was a typo with turn state")
	

func MoveAllDockedStrategyCardsToUsedPile(player):
	#a strategy card's cardIsDocked is only set if it is used
	#and this function only called if it is used successfully
	
	if player == "PlayerOne":
		#remember that if I wanted to use this card again, I would
		#have to set it's cardIsDocked to false again
		for x in playerOneUnusedStrategyCards:
			if x.GetCardIsDocked():
				x.SetCardInvolvedInBattle(true)	#this way the card will not be placed back in the dock
				x.hide()	#hide them, otherwise they will show up overtop of the cards in the card dock
				playerOneUnusedStrategyCards.erase(x)
				playerOneUsedStrategyCards.append(x)
	else:
		for x in playerTwoUnusedStrategyCards:
			if x.GetCardIsDocked():
				x.SetCardInvolvedInBattle(true)	#this way the card will not be placed back in the dock
				x.hide()	#hide them, otherwise they will show up overtop of the cards in the card dock
				playerTwoUnusedStrategyCards.erase(x)
				playerTwoUsedStrategyCards.append(x)
	


func AwardBattleVictoryPoint(player):
	if player == "PlayerOne":
		playerOnePoints += 1
	else:
		playerTwoPoints += 1
		
	#for now, victory is achieved after two battles are won
	if playerOnePoints == 2:
		print("player one wins the game")
		
	elif playerTwoPoints == 2:
		print("player two wins the game")
		

func _ready():
	pass
	
func RegisterBattleEnded():
	thereIsActiveBattle = false
	indexOfActiveLocationCardDock = -1
	playerWhoLandedlast = ""
	
func RegisterBattleStarted(index, lastPlayerToLand):
	thereIsActiveBattle = true
	indexOfActiveLocationCardDock = index
	playerWhoLandedlast = lastPlayerToLand
	#playerBattleTurn will be decided by the location card

func HandleStrategyCardMenuForCustomScript(text):
	
	var dock = locationDocks[0]	#doesn't matter which dock calls the func
	dock.HandleStrategyCardMenuForGameState(text)

func SetCurrentTurn(root):
	
	#player is either "PlayerOne" or "PlayerTwo"
	root.get_node("Dock").ClearAll()	#wipe the data in card dock
	#in card dock, it seems the values from dicts and the actual values are not the same, this could/will be the source of future problems
	
	#clear the cards of the player whose battle turn it was
	GameState.ClearPlayerCards(GameState.GetPlayerBattleTurn())	#make the unused cards of playerone(the ones that would be in the dock) invisible and unusable
	
	#restore the cards of the person whose current turn it is
	if GameState.GetCurrentTurn() == "PlayerOne":
		
		root.get_node("Dock").LoadPlayerCards(GameState.GetPlayerOneUnusedCards())
	else:
		
		root.get_node("Dock").LoadPlayerCards(GameState.GetPlayerTwoUnusedCards())
	


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


func FilterMonsterData(dataToFilter):
	#[attribute, health]
	for activeCard in activeCardsList:
		dataToFilter = activeCard.MonsterDataFilter(dataToFilter)
		
	return dataToFilter


func RestoreRegularTurnOrder(root):
	#if the player battle turn is different from current turn, set turn to current turn
	if GetCurrentTurn() != GetPlayerBattleTurn():
		SetCurrentTurn(root)	
		
	
	
	#clear playerBattleTurn
	SetPlayerBattleTurn("")
	
	#clear battle state
	SetBattleState("")
	
	


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
			if monsterCards[x].GetCardInvolvedInBattle() == true:
				
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
			if strategyCards[x].GetCardInvolvedInBattle() == true:
				#it's in the used pile, still should be hidden
				strategyCards[x].hide()
				strategyCards[x].set_process(false)
				strategyCards[x].set_physics_process(false)
				strategyCards[x].set_process_input(false)
			else:
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
			if monsterCards[x].GetCardInvolvedInBattle() == true:
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
			if strategyCards[x].GetCardInvolvedInBattle() == true:
				#it's in the used pile, it should be hidden
				strategyCards[x].hide()
				strategyCards[x].set_process(false)
				strategyCards[x].set_physics_process(false)
				strategyCards[x].set_process_input(false)
			else:
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
	
	
func PutMonsterCardsIntoUsedPiles():
	
	
	for card in playerOneUnusedMonsterCards:
		playerOneUnusedMonsterCards.erase(card)
		card.SetCardIsDocked(false)	#card is officially no longer a part of a battle
		
		playerOneUsedMonsterCards.append(card)
		
		
		
	for card in playerTwoUnusedMonsterCards:
		playerTwoUnusedMonsterCards.erase(card)
		card.SetCardIsDocked(false)	#card is officially no longer a part of a battle
		
		playerTwoUsedMonsterCards.append(card)
		
	
func PutActiveCardsIntoUsedPiles():
	#for battle cards set "cardisinvolvedinbattle" to false
	#only battle and location cards can become active cards
	
	#remove the cards from the unused piles
	
	for activeCard in activeCardsList:
		if activeCard.GetCardOwner() == "PlayerOne":
			if activeCard.GetCardType() == "Location":
				
				#set the cards "isDocked" to false
				activeCard.SetIsDocked(false)
				
				#remove the card from the unused pile
				playerOneUnusedLocationCards.erase(activeCard)	#this should remove the reference to the location card from the list
				
				playerOneUsedLocationCards.append(activeCard)	#now add the reference to the used cards
				
				#now remove the reference from the active cards list
				activeCardsList.erase(activeCard)
				
			elif activeCard.GetCardType() == "Battle":
				activeCard.SetCardIsInvolvedInBattle(false)
				activeCard.SetCardIsDocked(false)
				playerOneUnusedBattleCards.erase(activeCard)
				playerOneUsedBattleCards.append(activeCard)
				activeCardsList.erase(activeCard)
				
		elif activeCard.GetCardOwner() == "PlayerTwo":
			if activeCard.GetCardType() == "Location":
				#set the cards "isDocked" to false
				activeCard.SetIsDocked(false)
				
				#remove the card from the unused pile
				playerTwoUnusedLocationCards.erase(activeCard)	#this should remove the reference to the location card from the list
				
				playerTwoUsedLocationCards.append(activeCard)	#now add the reference to the used cards
				
				#now remove the reference from the active cards list
				activeCardsList.erase(activeCard)
				
				
			elif activeCard.GetCardType() == "Battle":
				activeCard.SetCardIsInvolvedInBattle(false)
				activeCard.SetCardIsDocked(false)
				playerTwoUnusedBattleCards.erase(activeCard)
				playerTwoUsedBattleCards.append(activeCard)
				activeCardsList.erase(activeCard)
	
func RestoreOriginalStatsToUsedMonsterCards():
	#in case a card's effect is to bring a card back from the unused pile or in case
	#one needs to come back from the unused pile, the cards should be ready to go with their original stats
	
	#reset for playerone
	for x in playerOneUsedMonsterCards:
		x.ResetData()	#this will reset health, attribute and clear damage taken.
	
	#reset for playertwo
	for x in playerTwoUsedMonsterCards:
		x.ResetData()

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
	
func SetPlayerMonsterDataAtCurrentBattleIndex(player, data):
	#player is either "PlayerOne" or "PlayerTwo"
	var dock = locationDocks[GetindexOfActiveLocationCardDock()]
	dock.SetPlayerMonsterData(player, data)
	
	
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
