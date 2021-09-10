extends Control


var locationCards = []
var monsterCards = []
var battleCards = []
var strategyCards = []

var showing = "Location"

func _ready():
	
	MakeAllCardsBlank()
	SetAllCardStates()
	LoadDeckAndBrowseMenuSelected()
	ShowLocationCards()


func RemoveCardFromDeck():
	#pop_back()
	if showing == "Location":
		locationCards.pop_back()	#even if list is empty, won't throw error because it will just return "nil"/"NULL"
		ShowLocationCards()
	if showing == "Monster":
		monsterCards.pop_back()
		ShowMonsterCards()
	if showing == "Battle":
		battleCards.pop_back()
		ShowBattleCards()
	if showing == "Strategy":
		strategyCards.pop_back()
		ShowStrategyCards()


func LoadDeckAndBrowseMenuSelected():
	var maxCardsOfAType = 5
	
	var cardSelectedReturn = DeckMenuHelper.GetCardSelected()	#returns a list: [cardtype, file]
	var getDeckReturn = DeckMenuHelper.GetDeck()	#returns a list: [location cards, monstercards, battlecards, strategycards]
	
	var selectedCardType = cardSelectedReturn[0]
	var selectedCardFile = cardSelectedReturn[1]
	
	locationCards = getDeckReturn[0]
	monsterCards = getDeckReturn[1]
	battleCards = getDeckReturn[2]
	strategyCards = getDeckReturn[3]
	
	#if the list of that kind of card is full, do not add the card
	#the user must delete a card of that type before adding another
	#otherwise add the card to the list
	
	if selectedCardType == "Location":
		if len(locationCards) < maxCardsOfAType:
			locationCards.append(selectedCardFile)
	
	if selectedCardType == "Monster":
		if len(monsterCards) < maxCardsOfAType:
			monsterCards.append(selectedCardFile)
			
	if selectedCardType == "Battle":
		if len(battleCards) < maxCardsOfAType:
			battleCards.append(selectedCardFile)
			
	if selectedCardType == "Strategy":
		if len(strategyCards) < maxCardsOfAType:
			strategyCards.append(selectedCardFile)
	
	
	
	#do load deck in ready from the global, remember I can use python x,y = func() return stuff style
func CallBrowseCardsMenu():
	#save the current deck information to the global deck helper, then change the menu
	DeckMenuHelper.SetDeck(locationCards, monsterCards, battleCards, strategyCards)
	get_tree().change_scene("res://Game/Scenes/Main/MainMenuAndSubMenus/BrowseCardsMenuFolder/BrowseCardsMenu.tscn")
	
	
func MakeAllCardsBlank():
	var minDisplayCardIndex = 1
	var maxDisplayCardIndex = 5
	
	for x in range(minDisplayCardIndex,maxDisplayCardIndex+1):
		#max is exclusive, hence +1
		var displayCard = get_node("DisplayCard"+str(x))
		displayCard.initAsBlank()
		
func SetAllCardStates():
	var minDisplayCardIndex = 1
	var maxDisplayCardIndex = 5
	
	for x in range(minDisplayCardIndex,maxDisplayCardIndex+1):
		#max is exclusive, hence +1
		var displayCard = get_node("DisplayCard"+str(x))
		displayCard.SetMenuState("EditMenus")
	
	
func ShowLocationCards():
	if len(locationCards) == 0:
		#make all cards blank
		MakeAllCardsBlank()
		
	elif len(locationCards) < 5:
		#show as many as there are cards and make the rest blank
		var amountOfCards = len(locationCards)
		var minDisplayCardIndex = 1
		var maxDisplayCardIndex = 5
	
		for x in range(minDisplayCardIndex,amountOfCards+1):
			#max is exclusive, hence +1
			var displayCard = get_node("DisplayCard"+str(x))
			displayCard.initAsLocationCard(locationCards[x-1])	#location cards are a list and start at zero, hence the -1
			
		for x in range(amountOfCards+1, maxDisplayCardIndex+1):
			#max is exclusive, hence +1. Also we've already set he card at amountOfCards
			var displayCard = get_node("DisplayCard"+str(x))
			displayCard.initAsBlank()	
			
		
	else:
		#there are 5 cards, show them all
		var minDisplayCardIndex = 1
		var maxDisplayCardIndex = 5
	
		for x in range(minDisplayCardIndex,maxDisplayCardIndex+1):
			#max is exclusive, hence +1
			var displayCard = get_node("DisplayCard"+str(x))
			displayCard.initAsLocationCard(locationCards[x-1])	#location cards are a list and start at zero, hence the -1
			

func ShowMonsterCards():
	if len(monsterCards) == 0:
		#make all cards blank
		MakeAllCardsBlank()
		
	elif len(monsterCards) < 5:
		#show as many as there are cards and make the rest blank
		var amountOfCards = len(monsterCards)
		var minDisplayCardIndex = 1
		var maxDisplayCardIndex = 5
	
		for x in range(minDisplayCardIndex,amountOfCards+1):
			#max is exclusive, hence +1
			var displayCard = get_node("DisplayCard"+str(x))
			displayCard.initAsMonsterCard(monsterCards[x-1])	#monster cards are a list and start at zero, hence the -1
			
		for x in range(amountOfCards+1, maxDisplayCardIndex+1):
			#max is exclusive, hence +1. Also we've already set he card at amountOfCards
			var displayCard = get_node("DisplayCard"+str(x))
			displayCard.initAsBlank()	
			
		
	else:
		#there are 5 cards, show them all
		var minDisplayCardIndex = 1
		var maxDisplayCardIndex = 5
	
		for x in range(minDisplayCardIndex,maxDisplayCardIndex+1):
			#max is exclusive, hence +1
			var displayCard = get_node("DisplayCard"+str(x))
			displayCard.initAsMonsterCard(monsterCards[x-1])	#monster cards are a list and start at zero, hence the -1
	
	
func ShowBattleCards():
	if len(battleCards) == 0:
		#make all cards blank
		MakeAllCardsBlank()
		
	elif len(battleCards) < 5:
		#show as many as there are cards and make the rest blank
		var amountOfCards = len(battleCards)
		var minDisplayCardIndex = 1
		var maxDisplayCardIndex = 5
	
		for x in range(minDisplayCardIndex,amountOfCards+1):
			#max is exclusive, hence +1
			var displayCard = get_node("DisplayCard"+str(x))
			displayCard.initAsBattleCard(battleCards[x-1])	#battle cards are a list and start at zero, hence the -1
			
		for x in range(amountOfCards+1, maxDisplayCardIndex+1):
			#max is exclusive, hence +1. Also we've already set he card at amountOfCards
			var displayCard = get_node("DisplayCard"+str(x))
			displayCard.initAsBlank()	
			
		
	else:
		#there are 5 cards, show them all
		var minDisplayCardIndex = 1
		var maxDisplayCardIndex = 5
	
		for x in range(minDisplayCardIndex,maxDisplayCardIndex+1):
			#max is exclusive, hence +1
			var displayCard = get_node("DisplayCard"+str(x))
			displayCard.initAsBattleCard(battleCards[x-1])	#battle cards are a list and start at zero, hence the -1
	
	
func ShowStrategyCards():
	if len(strategyCards) == 0:
		#make all cards blank
		MakeAllCardsBlank()
		
	elif len(strategyCards) < 5:
		#show as many as there are cards and make the rest blank
		var amountOfCards = len(strategyCards)
		var minDisplayCardIndex = 1
		var maxDisplayCardIndex = 5
	
		for x in range(minDisplayCardIndex,amountOfCards+1):
			#max is exclusive, hence +1
			var displayCard = get_node("DisplayCard"+str(x))
			displayCard.initAsStrategyCard(strategyCards[x-1])	#strategy cards are a list and start at zero, hence the -1
			
		for x in range(amountOfCards+1, maxDisplayCardIndex+1):
			#max is exclusive, hence +1. Also we've already set he card at amountOfCards
			var displayCard = get_node("DisplayCard"+str(x))
			displayCard.initAsBlank()	
			
		
	else:
		#there are 5 cards, show them all
		var minDisplayCardIndex = 1
		var maxDisplayCardIndex = 5
	
		for x in range(minDisplayCardIndex,maxDisplayCardIndex+1):
			#max is exclusive, hence +1
			var displayCard = get_node("DisplayCard"+str(x))
			displayCard.initAsStrategyCard(strategyCards[x-1])	#strategy cards are a list and start at zero, hence the -1
	


func _on_LocationCardButton_pressed():
	showing = "Location"
	ShowLocationCards()
	


func _on_MonsterCardButton_pressed():
	showing = "Monster"
	ShowMonsterCards()


func _on_BattleCardButton_pressed():
	showing = "Battle"
	ShowBattleCards()


func _on_StrategyCardButton_pressed():
	showing = "Strategy"
	ShowStrategyCards()
