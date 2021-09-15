extends Control


var locationCardDirectory = "res://Game/Assets/Card Files/location cards/"
var locationCards = []

var monsterCardDirectory = "res://Game/Assets/Card Files/monster cards/"
var monsterCards = []

var battleCardDirectory = "res://Game/Assets/Card Files/battle cards/"
var battleCards = []

var strategyCardDirectory = "res://Game/Assets/Card Files/strategy cards/"
var strategyCards = []

var indexInCardList = 0	#this is to help shifting to next 8 cards

var deckLocationCards = []
var deckMonsterCards = []
var deckBattleCards = []
var deckStrategyCards = []


func _ready():
	
	Settings.SetButtonToTheme($BackButton)
	Settings.SetButtonToTheme($NextButton)
	Settings.SetButtonToTheme($PreviouseButton)
	Settings.SetButtonToTheme($LocationCardsButton)
	Settings.SetButtonToTheme($MonsterCardsButton)
	Settings.SetButtonToTheme($BattleCardsButton)
	Settings.SetButtonToTheme($StrategyCardsButton)
	Settings.SetPanelToTheme($Panel)
	
	var returnedVals = MusicManager.GetCurrentMenuMusic()	#first is music, second is position in song
	var song = returnedVals[0]
	var songPos = returnedVals[1]
	$MenuMusic.stream = song
	$MenuMusic.play(songPos)
	
	LoadAllCards(GetFilePathsInDirectory(locationCardDirectory), GetFilePathsInDirectory(monsterCardDirectory), GetFilePathsInDirectory(battleCardDirectory), GetFilePathsInDirectory(strategyCardDirectory))
	ConnectAllCardSignals()
	SetAllMenuStates()
	DisplayLocationCards()
	
	#LoadCards(GetFilePathsInDirectory(monsterCardDirectory))

func LoadCards(Cards):
	var index = 1
	
	for x in Cards:
		var currentCard = get_node("DisplayCard"+str(index))
		
		currentCard.initAsMonsterCard(x)
		#maybe connect signals here
		get_node("FullCardinfo").ConnectCardSignals(currentCard)

#DeckMenuHelper.SetCardSelected(cardType, cardFile)
func SaveCardToDeck(cardType, file):
	DeckMenuHelper.SetCardSelected(cardType, file)
	get_tree().change_scene("res://Game/Scenes/Main/DeckMenus/EditDecksMenu.tscn")

func ConnectAllCardSignals():
	#since we're not add_child() instancing the cards in, we can connect
	#their signals once and never have to do it again
	var minIndex = 1
	var maxIndex = 8
	
	for x in range(minIndex, maxIndex+1):
		#max is exclusive
		var currentCard = get_node("DisplayCard"+str(x))
		get_node("FullCardinfo").ConnectCardSignals(currentCard)
	
func SetAllMenuStates():
	
	var minIndex = 1
	var maxIndex = 8
	
	for x in range(minIndex, maxIndex+1):
		#max is exclusive
		var currentCard = get_node("DisplayCard"+str(x))
		currentCard.SetMenuState("BrowseMenu")
	
func LoadAllCards(locations, monsters, battles, strategys):
	#loading cards and displaying them to the cards is different
	locationCards = locations
	monsterCards = monsters
	battleCards = battles
	strategyCards = strategys
	
func DisplayStrategyCards():
	var numberOfStrategyCards = len(strategyCards)
	#how many cards are there in locationCards?
	
	var numberOfDisplayCards = 8
	
	if numberOfStrategyCards > numberOfDisplayCards:
		#enable next and previouse etc.
		var index = 1
		
		for x in range(0,numberOfStrategyCards+1):
			#max is exclusive, hence +1
			var currentCard = get_node("DisplayCard"+str(index))
		
			currentCard.initAsStrategyCard(strategyCards[x])
			index += 1
		
	elif numberOfStrategyCards == numberOfDisplayCards:
		#fill all display cards, disable next and previouse
		var index = 1
		
		for x in strategyCards:
			var currentCard = get_node("DisplayCard"+str(index))
		
			currentCard.initAsStrategyCard(x)
			index += 1
		
	elif numberOfStrategyCards < numberOfDisplayCards:
		#hide unneeded display cards, disable next and previouse
		var index = 1
		
		for x in strategyCards:
			var currentCard = get_node("DisplayCard"+str(index))
		
			currentCard.initAsStrategyCard(x)
			index += 1
			
		#for all indexs which do not have a card, hide them
		while index < numberOfDisplayCards+1:
			var currentCard = get_node("DisplayCard"+str(index))
			currentCard.hide()
			index += 1
	
	
func DisplayBattleCards():
	var numberOfBattleCards = len(battleCards)
	#how many cards are there in locationCards?
	
	var numberOfDisplayCards = 8
	
	if numberOfBattleCards > numberOfDisplayCards:
		#enable next and previouse etc.
		var index = 1
		
		for x in range(0,numberOfBattleCards+1):
			#max is exclusive, hence +1
			var currentCard = get_node("DisplayCard"+str(index))
		
			currentCard.initAsBattleCard(battleCards[x])
			index += 1
		
	elif numberOfBattleCards == numberOfDisplayCards:
		#fill all display cards, disable next and previouse
		var index = 1
		
		for x in battleCards:
			var currentCard = get_node("DisplayCard"+str(index))
		
			currentCard.initAsBattleCard(x)
			index += 1
		
	elif numberOfBattleCards < numberOfDisplayCards:
		#hide unneeded display cards, disable next and previouse
		var index = 1
		
		for x in battleCards:
			var currentCard = get_node("DisplayCard"+str(index))
		
			currentCard.initAsBattleCard(x)
			index += 1
			
		#for all indexs which do not have a card, hide them
		while index < numberOfDisplayCards+1:
			var currentCard = get_node("DisplayCard"+str(index))
			currentCard.hide()
			index += 1
	
	
func DisplayMonsterCards():
	var numberOfMonsterCards = len(monsterCards)
	#how many cards are there in locationCards?
	
	var numberOfDisplayCards = 8
	
	if numberOfMonsterCards > numberOfDisplayCards:
		#enable next and previouse etc.
		var index = 1
		
		for x in range(0,numberOfMonsterCards+1):
			#max is exclusive, hence +1
			var currentCard = get_node("DisplayCard"+str(index))
		
			currentCard.initAsMonsterCard(monsterCards[x])
			index += 1
		
	elif numberOfMonsterCards == numberOfDisplayCards:
		#fill all display cards, disable next and previouse
		var index = 1
		
		for x in monsterCards:
			var currentCard = get_node("DisplayCard"+str(index))
		
			currentCard.initAsMonsterCard(x)
			index += 1
		
	elif numberOfMonsterCards < numberOfDisplayCards:
		#hide unneeded display cards, disable next and previouse
		var index = 1
		
		for x in monsterCards:
			var currentCard = get_node("DisplayCard"+str(index))
		
			currentCard.initAsMonsterCard(x)
			index += 1
			
		#for all indexs which do not have a card, hide them
		while index < numberOfDisplayCards+1:
			var currentCard = get_node("DisplayCard"+str(index))
			currentCard.hide()
			index += 1
	
func DisplayLocationCards():
	var numberOfLocationCards = len(locationCards)
	#how many cards are there in locationCards?
	
	var numberOfDisplayCards = 8
	
	if numberOfLocationCards > numberOfDisplayCards:
		#enable next and previouse etc.
		var index = 1
		
		for x in range(0,numberOfLocationCards+1):
			#max is exclusive, hence +1
			var currentCard = get_node("DisplayCard"+str(index))
		
			currentCard.initAsLocationCard(locationCards[x])
			index += 1
		
	elif numberOfLocationCards == numberOfDisplayCards:
		#fill all display cards, disable next and previouse
		var index = 1
		
		for x in locationCards:
			var currentCard = get_node("DisplayCard"+str(index))
		
			currentCard.initAsLocationCard(x)
			index += 1
		
	elif numberOfLocationCards < numberOfDisplayCards:
		#hide unneeded display cards, disable next and previouse
		var index = 1
		
		for x in locationCards:
			var currentCard = get_node("DisplayCard"+str(index))
		
			currentCard.initAsLocationCard(x)
			index += 1
			
		#for all indexs which do not have a card, hide them
		while index < numberOfDisplayCards+1:
			var currentCard = get_node("DisplayCard"+str(index))
			currentCard.hide()
			index += 1
		
		
	
	#if 8 or more, show eight at a time, when next is pressed show next eight etc.
	#maybe in this case turn off "next" button with a variable etc.
	#if less than eight we'll have to hide some of the display cards
	

#dir is the path to a dictory
#this function takes a directory and returns the full paths to files, ["c:/hello.txt"] for example
func GetFilePathsInDirectory(dir):
	
	var fileNames = list_files_in_directory(dir)
	var filePaths = []
	#to read from the file, it will need the full path to the file
	for x in fileNames:
		filePaths.append(dir+x)
		
	return filePaths
	
	
#path, a file path
func list_files_in_directory(path):
	var files = []
	var dir = Directory.new()
	dir.open(path)
	dir.list_dir_begin()

	while true:
		var file = dir.get_next()
		if file == "":
			break
		elif not file.begins_with("."):
			files.append(file)

	dir.list_dir_end()

	return files


func _on_PreviouseButton_pressed():
	pass # Replace with function body.


func _on_NextButton_pressed():
	pass # Replace with function body.


func _on_LocationCardsButton_pressed():
	DisplayLocationCards()


func _on_MonsterCardsButton_pressed():
	DisplayMonsterCards()


func _on_BattleCardsButton_pressed():
	DisplayBattleCards()


func _on_StrategyCardsButton_pressed():
	DisplayStrategyCards()




func _on_BackButton_pressed():
	MusicManager.SetMenuMusicPlaybackPosition($MenuMusic.get_playback_position())
	get_tree().change_scene("res://Game/Scenes/Main/DeckMenus/EditDecksMenu.tscn")
