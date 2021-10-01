extends Node

onready var turn = "PlayerOne"	#start the game on the first player's turn

onready var locationDocks = []	#location docks are numbered 1-9 from bottom left to top right
#don't keep stuff other than references, manip values in the docks to check/edit things



var sceneRoot = load("res://Game/Scripts/Main/Root.gd")

#player one stuff
var playerOnePoints = 0	#you get points by winning battles, if you win enough battles you win the game

var cardWasSelected = false

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

var strategyCardBeingPlayed = false

#for browse card menu
var playerOneLocationCardDeck = []
var playerOneMonsterCardDeck = []
var playerOneBattleCardDeck = []
var playerOneStrategyCardDeck = []

var playerTwoLocationCardDeck = []
var playerTwoMonsterCardDeck = []
var playerTwoBattleCardDeck = []
var playerTwoStrategyCardDeck = []

var firstTimeCalled = true


func GetSetADeckFirstTime():
	return firstTimeCalled

func SetADeck(locations, monsters, battles, strategys):
	#if it's the first time called, this is player one's deck. Else, player two's
	if firstTimeCalled:
		firstTimeCalled = false
		playerOneLocationCardDeck = locations
		playerOneMonsterCardDeck = monsters
		playerOneBattleCardDeck = battles
		playerOneStrategyCardDeck = strategys
		
	else:
		playerTwoLocationCardDeck = locations
		playerTwoMonsterCardDeck = monsters
		playerTwoBattleCardDeck = battles
		playerTwoStrategyCardDeck = strategys

func GetADeck(cardType, player):
	if player == "PlayerOne":
		if cardType == "Location":
			return playerOneLocationCardDeck
		elif cardType == "Monster":
			return playerOneMonsterCardDeck
		elif cardType == "Battle":
			return playerOneBattleCardDeck
		elif cardType == "Strategy":
			return playerOneStrategyCardDeck
	else:
		if cardType == "Location":
			return playerTwoLocationCardDeck
		elif cardType == "Monster":
			return playerTwoMonsterCardDeck
		elif cardType == "Battle":
			return playerTwoBattleCardDeck
		elif cardType == "Strategy":
			return playerTwoStrategyCardDeck

#end of for browse card menu

func GetStrategyCardBeingPlayed():
	return strategyCardBeingPlayed
	
func SetStrategyCardBeingPlayed(newVal):
	strategyCardBeingPlayed = newVal

func HudGetAdvice():
	#if there is a battle, return advice based on battle phase
	#otherwise return advice based on turn phase
	var advice = ""
	
	if battleState == "":
		#there is no battle, return advice based on turn phase
		#the turn phases are Setup, LocationCardPhase
		#MonsterCardPhase, StrategyCardPhase
		
		if turnState == "Setup":
			advice = "Place down a location card and end your turn"
			
		if turnState == "LocationCardPhase":
			advice = "Place down a location card on a location card dock(grey squares)"
		
		if turnState == "MonsterCardPhase":
			advice = "Place down a monster card on a location card dock(grey squares).\n If your opponent already has one there, you'll start a battle."
		
		if turnState == "StrategyCardPhase":
			advice = "Place a strategy you want to play on a \nlocation card dock(grey squares) to activate it's effect if possible."
		
	else:
		#there is a battle, return advice based on battle phase
		#the battle phases are MonsterAttackPhase, BattleCardPhase
		if battleState == "MonsterAttackPhase":
			advice = "right click on your monster and select an action for it to take from the attack menu"
			
		if battleState == "BattleCardPhase":
			advice = "Place a battle card you want to play onto the location card dock\n the battle is happening on to activate it"
	
	return advice


func GetCardWasSelected():
	return cardWasSelected
	
func SetCardWasSelected(newVal):
	cardWasSelected = newVal


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
	
#player is either "PlayerOne" or "PlayerTwo"
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
	

func GetOneCardBackFromUsedPile(cardType, player):
	#make sure to check both here and elsewhere that there are cards in the lists!
	
	#move the cards of type "cardType" from the player's used pile to their
	#unused pile
	if player == "PlayerOne":
		if cardType == "Location":
			
			
			#add to unused,
			playerOneUnusedLocationCards.append(playerOneUsedLocationCards[-1])
				
			#remove from used
			playerOneUsedLocationCards.erase(playerOneUsedLocationCards[-1])
			
			
		if cardType == "Monster":
			
			#add to unused,
			playerOneUnusedMonsterCards.append(playerOneUsedMonsterCards[-1])
				
			#remove from used
			playerOneUsedMonsterCards.erase(playerOneUsedMonsterCards[-1])
			
			
		if cardType == "Battle":
			
			#add to unused,
			playerOneUnusedBattleCards.append(playerOneUsedBattleCards[-1])
				
			#remove from used
			playerOneUsedBattleCards.erase(playerOneUsedBattleCards[-1])
			
			
		if cardType == "Strategy":
			
			#add to unused,
			playerOneUnusedStrategyCards.append(playerOneUsedStrategyCards[-1])
				
			#remove from used
			playerOneUsedStrategyCards.erase(playerOneUsedStrategyCards[-1])
	
	elif player == "PlayerTwo":
		if cardType == "Location":
			
			#add to unused,
			playerTwoUnusedLocationCards.append(playerTwoUsedLocationCards[-1])
				
			#remove from used
			playerTwoUsedLocationCards.erase(playerTwoUsedLocationCards[-1])
			
			
		if cardType == "Monster":
			
			#add to unused,
			playerTwoUnusedMonsterCards.append(playerTwoUsedMonsterCards[-1])
				
			#remove from used
			playerTwoUsedMonsterCards.erase(playerTwoUsedMonsterCards[-1])
			
			
		if cardType == "Battle":
			
			#add to unused,
			playerTwoUnusedBattleCards.append(playerTwoUsedBattleCards[-1])
				
			#remove from used
			playerTwoUsedBattleCards.erase(playerTwoUsedBattleCards[-1])
			
			
		if cardType == "Strategy":
			
			#add to unused,
			playerTwoUnusedStrategyCards.append(playerTwoUsedStrategyCards[-1])
				
			#remove from used
			playerTwoUsedStrategyCards.erase(playerTwoUsedStrategyCards[-1])

func GiveLocationCardToDockAtIndex(index, card):
	var dock = locationDocks[index]
	dock.CardEffectPlaceLocationCard(card)

func TakeLocationCardFromDockAtIndex(index):
	var dock = locationDocks[index]
	return dock.CardEffectRemoveLocationCard()

func TakeMonsterFromDockAtIndex(index, player):
	var dock = locationDocks[index]
	return dock.CardEffectRemoveMonster(player)
	
func GiveMonsterToDockAtIndex(index, player, card):
	var dock = locationDocks[index]
	dock.CardEffectPlaceMonster(player, card)
	


func GetCardsBackFromUsedPile(cardType, player):
	#move the cards of type "cardType" from the player's used pile to their
	#unused pile
	if player == "PlayerOne":
		if cardType == "Location":
			for x in playerOneUsedLocationCards:
				#add to unused,
				playerOneUnusedLocationCards.append(x)
				
				#remove from used
				playerOneUsedLocationCards.erase(x)
			
			
		if cardType == "Monster":
			for x in playerOneUsedMonsterCards:
				#add to unused,
				playerOneUnusedMonsterCards.append(x)
				
				#remove from used
				playerOneUsedMonsterCards.erase(x)
			
			
		if cardType == "Battle":
			for x in playerOneUsedBattleCards:
				#add to unused,
				playerOneUnusedBattleCards.append(x)
				
				#remove from used
				playerOneUsedBattleCards.erase(x)
			
			
		if cardType == "Strategy":
			for x in playerOneUsedStrategyCards:
				#add to unused,
				playerOneUnusedStrategyCards.append(x)
				
				#remove from used
				playerOneUsedStrategyCards.erase(x)
	
	elif player == "PlayerTwo":
		if cardType == "Location":
			for x in playerTwoUsedLocationCards:
				#add to unused,
				playerTwoUnusedLocationCards.append(x)
				
				#remove from used
				playerTwoUsedLocationCards.erase(x)
			
			
		if cardType == "Monster":
			for x in playerTwoUsedMonsterCards:
				#add to unused,
				playerTwoUnusedMonsterCards.append(x)
				
				#remove from used
				playerTwoUsedMonsterCards.erase(x)
			
			
		if cardType == "Battle":
			for x in playerTwoUsedBattleCards:
				#add to unused,
				playerTwoUnusedBattleCards.append(x)
				
				#remove from used
				playerTwoUsedBattleCards.erase(x)
			
			
		if cardType == "Strategy":
			for x in playerTwoUsedStrategyCards:
				#add to unused,
				playerTwoUnusedStrategyCards.append(x)
				
				#remove from used
				playerTwoUsedStrategyCards.erase(x)
	

func DisplayLocationCardAtIndex(index):
	var dock = locationDocks[index]
	dock.DisplayCurrentLocationCard()

func GetPlayerVictoryPoints(player):
	if player == "PlayerOne":
		return playerOnePoints
	else:
		return playerTwoPoints

#player is either "PlayerOne" or "PlayerTwo"
func AwardBattleVictoryPoint(player, root):
	root.StopBattleMusic()
	#stop the battle music now that the battle is over
	
	if player == "PlayerOne":
		playerOnePoints += 1
	else:
		playerTwoPoints += 1
		
	#for now, victory is achieved after two battles are won
	if playerOnePoints == 2:
		root.HandleVictoryMenu(player)
		
	elif playerTwoPoints == 2:
		root.HandleVictoryMenu(player)
		

func _ready():
	pass
	
func RegisterBattleEnded():
	thereIsActiveBattle = false
	indexOfActiveLocationCardDock = -1	#-1 is not a valid location dock number, so if it was used when it wasn't supposed to be it would cause an error
	playerWhoLandedlast = ""
	
#index is a number 1-9, represents a location dock
#lastPlayerToLand is either "PlayerOne" or "PlayerTwo"
func RegisterBattleStarted(index, lastPlayerToLand):
	thereIsActiveBattle = true
	indexOfActiveLocationCardDock = index
	playerWhoLandedlast = lastPlayerToLand
	#playerBattleTurn will be decided by the location card

func GetThereIsActiveBattle():
	return thereIsActiveBattle

#text is the text prompt the strategy card menu will show to the user
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
	
#this is used by card effects that give players back used cards
#during a battle
func ReloadPlayerCards(player):
	if player == "PlayerOne":
		sceneRoot.get_node("Dock").LoadPlayerCards(GameState.GetPlayerOneUnusedCards())
	elif player == "PlayerTwo":
		sceneRoot.get_node("Dock").LoadPlayerCards(GameState.GetPlayerTwoUnusedCards())
	

func GetCurrentTurn():
	return turn

func ChangeCurrentTurn():
	#this is setup this way to prevent spelling mistakes from breaking the turn system
	if turn == "PlayerOne":
		turn = "PlayerTwo"
	else:
		turn = "PlayerOne"

#index is a number 1-9, represents a location dock
#monsterAttack is a monster attack in the form: [1, "flaming Sting", 60, "Inferno", "there is a one in eight chance this attack does 100 damage", true, true]
#where the the information is: the index of the attack(first attack), name of the attack, damage of the attack, attribute of the attack, text effect of the attack, whether the effect is enabled, whether the attack is allowed
#this function does the monster card's effect at the location dock where the battle is happening
func DoMonsterEffectAtCurrentBattleIndex(index, monsterAttack):
	var dock = locationDocks[index]
	return dock.UseMonsterCardEffect(monsterAttack)
	#returns monster attack
	
#index is a number 1-9, represents a location dock
#monsterAttack is a monster attack in the form: [1, "flaming Sting", 60, "Inferno", "there is a one in eight chance this attack does 100 damage", true, true]
#where the the information is: the index of the attack(first attack), name of the attack, damage of the attack, attribute of the attack, text effect of the attack, whether the effect is enabled, whether the attack is allowed
#this function deals damage to the monster opposing the one the attack originated from at the location dock where the battle is happening
func DealDamageToOtherMonsterAtCurrentBattleIndex(index, monsterAttack):
	var dock = locationDocks[index]
	dock.DealDamageToMonster(monsterAttack)
	
#this is made for card scripts who might not want to make a whole monster attack to hurt another
func DealDamageToMonsterAtCurrentBattleIndex(player, damage):
	var dock = locationDocks[indexOfActiveLocationCardDock]
	dock.DealDamageToMonsterGivenPlayer(player, damage)
	
func GiveHealthToMonsterAtCurrentBattleIndex(player, health):
	var dock = locationDocks[indexOfActiveLocationCardDock]
	dock.GiveHealthToMonster(player, health)
	
#index is a number 1-9, represents a location dock
func CheckForVictoryAtCurrentBattleIndex(index):
	var dock = locationDocks[index]
	return dock.GetVictory()
	
#card is a reference to a card node/object
func AddCardToActiveCardList(card):
	#add the card and give it a priority, the more recent it is the higher the priority
	card.SetPriority(activeCardPriority)
	activeCardPriority += 1	
	activeCardsList.append(card)
	
	
#attacksToFilter is a list of monster attacks, each of which is in the form: 
# [1, "flaming Sting", 60, "Inferno", "there is a one in eight chance this attack does 100 damage", true, true]
#where the the information is: the index of the attack(first attack), name of the attack, damage of the attack, attribute of the attack, text effect of the attack, whether the effect is enabled, whether the attack is allowed
#this function filters all monster attacks through all active cards
func FilterMonsterCardAttacks(attacksToFilter):
	#for in range through active cards, call the filter func of that active thing
	var filteredAttacks = []
	for attack in attacksToFilter:
		for activeCard in activeCardsList:
			attack = activeCard.FilterAttack(attack)
			
		filteredAttacks.append(attack)
	return filteredAttacks
	#this function returns the list of attacks
	
#battleCardToFilter is in the form: [attribute, true] where attribute is the attribute of the card and true is whether or not the card is allowed to be played
#this function filters the battle card through all active cards
func FilterBattleCard(battleCardToFilter):
	for activeCard in activeCardsList:
		battleCardToFilter = activeCard.BattleCardFilter(battleCardToFilter)
		
	return battleCardToFilter

#dataToFilter is in the form [attribute, health]
func FilterMonsterData(dataToFilter):
	#[attribute, health]
	for activeCard in activeCardsList:
		dataToFilter = activeCard.MonsterDataFilter(dataToFilter)
		
	return dataToFilter

#root is a reference to the root scene
func RestoreRegularTurnOrder(root):
	#if the player battle turn is different from current turn, set turn to current turn
	if GetCurrentTurn() != GetPlayerBattleTurn():
		SetCurrentTurn(root)	
		
	
	
	#clear playerBattleTurn
	SetPlayerBattleTurn("")
	
	#clear battle state
	SetBattleState("")
	
	

#player is either "PlayerOne" or "PlayerTwo"
func ClearPlayerCards(player):
	
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
	
#used by a location card's effect, "Tiko's Hut"
func GetCurrentTurnMonsterNameAtCurrentBattleIndex():
	#get the monster who is attacking(monster belonging to the player whose
	#current battle turn it is)
	var dock = locationDocks[indexOfActiveLocationCardDock]
	
	if playerBattleTurn == "PlayerOne":
		return dock.GetMonsterName(playerBattleTurn)
	else:
		return dock.GetMonsterName(playerBattleTurn)
	
	
#this function is used by the active effects browser menu
func GetActiveCardsInformation():
	var toReturn = []
	var toAppend = []
	
	for card in activeCardsList:
		toAppend.append(card.GetCardName())
		toAppend.append(card.GetCardType())
		toAppend.append(card.GetCardEffect())
		toReturn.append(toAppend)
		toAppend = []
	return toReturn
	
	
func PutMonsterCardsIntoUsedPiles():
	
	
	for card in playerOneUnusedMonsterCards:
		if card.GetCardInvolvedInBattle():
			playerOneUnusedMonsterCards.erase(card)
			card.SetCardIsDocked(false)	#card is officially no longer a part of a battle
			card.SetCardInvolvedInBattle(false)	#if this stays true, load cards in card dock will show it and clear all here won't clear it
			playerOneUsedMonsterCards.append(card)
		
		
		
	for card in playerTwoUnusedMonsterCards:
		if card.GetCardInvolvedInBattle():
			playerTwoUnusedMonsterCards.erase(card)
			card.SetCardIsDocked(false)	#card is officially no longer a part of a battle
			card.SetCardInvolvedInBattle(false)
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
	
#index is a number 1-9, represents a location dock
func SetLocationCardAtIndexToHidden(index):
	#I need this function otherwise the shown location card will draw over
	#the attack selection dialogue, which looks terrible
	var dock = locationDocks[index]
	dock.SetLocationDockToHidden()
	
#index is a number 1-9, represents a location dock
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
	
	
#player is either "PlayerOne" or "PlayerTwo"
#data is in the form [attribute, health]
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
	
	
	#filter the current player's monster that's involved in the battle!
	GameState.FilterMonsterData(GetPlayerMonsterDataAtCurrentBattleIndex(GameState.GetPlayerBattleTurn()))
	
#newLocationDock is a reference to a location dock object
func AddLocationDock(newLocationDock):
	locationDocks.append(newLocationDock)
	
#add cards for player one
#newLocationCard is a reference to a location card object
func AddPlayerOneLocationCard(newLocationCard):
	playerOneUnusedLocationCards.append(newLocationCard)
	
#newMonsterCard is a reference to a monster card object
func AddPlayerOneMonsterCard(newMonsterCard):
	playerOneUnusedMonsterCards.append(newMonsterCard)
	
	
#newBattleCard is a reference to a battle card object
func AddPlayerOneBattleCard(newBattleCard):
	playerOneUnusedBattleCards.append(newBattleCard)
	
#newStrategyCard is a reference to a strategy card object
func AddPlayerOneStrategyCard(newStrategyCard):
	playerOneUnusedStrategyCards.append(newStrategyCard)
	
#get unused cards
func GetPlayerOneUnusedCards():
	
	return [playerOneUnusedLocationCards, playerOneUnusedMonsterCards, playerOneUnusedBattleCards, playerOneUnusedStrategyCards]
	
func GetPlayerTwoUnusedCards():
	
	return [playerTwoUnusedLocationCards, playerTwoUnusedMonsterCards, playerTwoUnusedBattleCards, playerTwoUnusedStrategyCards]
	
	
#get used cards(used in at least the battle card Strategists Demise)
func GetPlayerOneUsedCards():
	
	return [playerOneUsedLocationCards, playerOneUsedMonsterCards, playerOneUsedBattleCards, playerOneUsedStrategyCards]
	
func GetPlayerTwoUsedCards():
	
	return [playerTwoUsedLocationCards, playerTwoUsedMonsterCards, playerTwoUsedBattleCards, playerTwoUsedStrategyCards]
	
	
	
#add cards for player two
#newLocationCard is a reference to a location card object
func AddPlayerTwoLocationCard(newLocationCard):
	playerTwoUnusedLocationCards.append(newLocationCard)
	
#newMonsterCard is a reference to a monster card object
func AddPlayerTwoMonsterCard(newMonsterCard):
	playerTwoUnusedMonsterCards.append(newMonsterCard)
	
	
#newBattleCard is a reference to a battle card object
func AddPlayerTwoBattleCard(newBattleCard):
	playerTwoUnusedBattleCards.append(newBattleCard)
	
#newStrategyCard is a reference to a strategy card object
func AddPlayerTwoStrategyCard(newStrategyCard):
	playerTwoUnusedStrategyCards.append(newStrategyCard)
