extends Control


var locationCards = []
var monsterCards = []
var battleCards = []
var strategyCards = []

var showing = "Location"

var savedDecksDirectory = "res://Game/Assets/SavedDecksFolder/"

func _ready():

	Settings.SetButtonToTheme($LocationCardButton)
	Settings.SetButtonToTheme($MonsterCardButton)
	Settings.SetButtonToTheme($BattleCardButton)
	Settings.SetButtonToTheme($StrategyCardButton)
	Settings.SetButtonToTheme($BackButton)
	Settings.SetButtonToTheme($SaveDeckButton)
	Settings.SetPanelToTheme($Panel)

	var returnedVals = MusicManager.GetCurrentMenuMusic()	#first is music, second is position in song
	var song = returnedVals[0]
	var songPos = returnedVals[1]
	$MenuMusic.stream = song
	$MenuMusic.play(songPos)

	MakeAllCardsBlank()
	SetAllCardStates()
	LoadDeckAndBrowseMenuSelected()
	ShowLocationCards()
	DeckMenuHelper.SetCurrentlyShowingCardType("Location")	#set it so it has a default and doesn't cause problems


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

	var deckName = DeckMenuHelper.GetDeckName()
	if deckName != "":
		$TextEdit.text = deckName

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

	#if selected card is nothing, "", it will fail all of these

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
	DeckMenuHelper.SetCurrentlyShowingCardType("Location")
	ShowLocationCards()



func _on_MonsterCardButton_pressed():
	showing = "Monster"
	DeckMenuHelper.SetCurrentlyShowingCardType("Monster")
	ShowMonsterCards()


func _on_BattleCardButton_pressed():
	showing = "Battle"
	DeckMenuHelper.SetCurrentlyShowingCardType("Battle")
	ShowBattleCards()


func _on_StrategyCardButton_pressed():
	showing = "Strategy"
	DeckMenuHelper.SetCurrentlyShowingCardType("Strategy")
	ShowStrategyCards()


func _on_BackButton_pressed():
	MusicManager.SetMenuMusicPlaybackPosition($MenuMusic.get_playback_position())
	#clear the DeckMenuHelper deck stuff and go back to deck selection menu
	DeckMenuHelper.SetDeckName("")	#clear the current deck name
	DeckMenuHelper.SetDeck([], [], [], [])	#clear the working deck
	DeckMenuHelper.SetCardSelected("", "")
	get_tree().change_scene("res://Game/Scenes/Main/DeckMenus/DisplayDecksMenu.tscn")

func saveDeck(fileName):
	var file = File.new()
	file.open(savedDecksDirectory+fileName, File.WRITE)
	#file.store_string(content)	#appends data to file without line ends
	#save the location cards to the file
	for x in locationCards:
		file.store_string(x + "\n")

	for x in monsterCards:
		file.store_string(x + "\n")

	for x in battleCards:
		file.store_string(x + "\n")

	for x in strategyCards:
		file.store_string(x + "\n")

	file.close()

func _on_SaveDeckButton_pressed():
	MusicManager.SetMenuMusicPlaybackPosition($MenuMusic.get_playback_position())

	var fullDeckAmount = 5
	#save the deck only if it's full, if it has no name give it a name
	var possibleDeckName = $TextEdit.text
	var actualDeckName = ""

	if possibleDeckName == "" or possibleDeckName == " " or possibleDeckName == "\n":
		#it's not a valid deck name
		actualDeckName = "MyDeck.txt"

	else:
		actualDeckName = possibleDeckName + ".txt"


	if len(locationCards) == fullDeckAmount and len(monsterCards) == fullDeckAmount and len(battleCards) == fullDeckAmount and len(strategyCards) == fullDeckAmount:
		#save

		saveDeck(actualDeckName)
		get_tree().change_scene("res://Game/Scenes/Main/DeckMenus/DisplayDecksMenu.tscn")
	else:
		#not a full deck, don't save
		get_tree().change_scene("res://Game/Scenes/Main/DeckMenus/DisplayDecksMenu.tscn")


