extends Node2D

var experimentalCardDirectory = "res://Game/Assets/Card Files/experimental/"
#I'd read in all the cards from several folders, all location cards, battle cards etc
var experimentalBaseCardClass = load("res://Game/Scenes/Experimental/Card Experiment.tscn")

var locationCardDirectory = "res://Game/Assets/Card Files/location cards/"
var locationCardClass = load("res://Game/Scenes/Experimental/Location Card.tscn")

var monsterCardDirectory = "res://Game/Assets/Card Files/monster cards/"
var monsterCardClass = load("res://Game/Scenes/Experimental/Monster card.tscn")

#signals for the location cards
signal battleStart(gameState, battleCardItIsOn)	#send the gameState so the location card can manipulate it and the card it's on so only the right location card is used
signal battleCardUsed(gameState, battleCardItIsOn)	
signal battleEnd(gameState, battleCardItIsOn)

onready var locationDockOne = $LocationDock1
onready var locationDockTwo = $LocationDock2
onready var locationDockThree = $LocationDock3
onready var locationDockFour = $LocationDock4
onready var locationDockFive = $LocationDock5
onready var locationDockSix = $LocationDock6
onready var locationDockSeven = $LocationDock7
onready var locationDockEight = $LocationDock8
onready var locationDockNine = $LocationDock9
onready var listOfLocationDocks = [locationDockOne, locationDockTwo, locationDockThree, locationDockFour, locationDockFive, locationDockSix, locationDockSeven, locationDockEight, locationDockNine]


func _ready():
	GameState.SetLocationDocks(listOfLocationDocks)
	#load_base_card_class(GetFilePathsInDirectory(experimentalCardDirectory))
	#load_location_cards(GetFilePathsInDirectory(locationCardDirectory))
	#load_monster_cards(GetFilePathsInDirectory(monsterCardDirectory))
	load_playerone_cards(GetFilePathsInDirectory(locationCardDirectory), GetFilePathsInDirectory(monsterCardDirectory))
	load_playertwo_cards(GetFilePathsInDirectory(locationCardDirectory), GetFilePathsInDirectory(monsterCardDirectory))
	
	GameState.ClearPlayerCards("PlayerTwo")	#it's player one's turn first
	
	get_node("Dock").LoadPlayerCards(GameState.GetPlayerOneUnusedCards())
	#GameState.ChangeCurrentTurn()
	#I can now handle changing turns with cards in the card dock, now I need to handle the location card docks and any cards that might be in/on them
	#get_node("Dock").ClearAll()	#wipe the data in card dock
	#in card dock, it seems the values from dicts and the actual values are not the same, this could/will be the source of future problems
	#GameState.ClearPlayerCards("PlayerOne")	#make the unused cards of playerone(the ones that would be in the dock) invisible and unusable
	
	#get_node("Dock").LoadPlayerCards(GameState.GetPlayerTwoUnusedCards())
	
	#get_node("Dock").LoadPlayerCards(GameState.GetPlayerTwoUnusedCards())
	#these work and trigger code in the custom script
	#emit_signal("battleStart", 0, 0)
	#emit_signal("battleEnd",0,0)
	#emit_signal("battleCardUsed",0,0)
	
func GetFilePathsInDirectory(dir):
	#load the one card into the scene by reading the card's text file from directory
	var fileNames = list_files_in_directory(dir)
	var filePaths = []
	#to read from the file, it will need the full path to the file
	for x in fileNames:
		filePaths.append(dir+x)
		
	return filePaths
	
func load_base_card_class(files):
	for x in files:
		
		var newCard = experimentalBaseCardClass.instance()
		
		add_child(newCard)	#if this comes after init() there are some errors with the children being NIL bases
		newCard.init(x, "PlayerOne")
		newCard.SetCardType("Other")
		#get_node("Dock").PlaceOtherCard(newCard)
				
				
				
		#connect the card signals
		#this should mean I can connect the signals of loaded/instanced scripts as well in a similar fashion(location, battle etc. cards)
		get_node("Display").ConnectCardSignal(newCard)
			
		
			
			
func load_location_cards(files):
	for x in files:
		
		var newCard = locationCardClass.instance()
		
		add_child(newCard)	#if this comes after init() there are some errors with the children being NIL bases
		newCard.init(x, "PlayerOne")
		
		#get_node("Dock").PlaceOtherCard(newCard)
				
				
				
		#connect the card signals
		#this should mean I can connect the signals of loaded/instanced scripts as well in a similar fashion(location, battle etc. cards)
		get_node("Display").ConnectCardSignal(newCard)
		#more signal connections will be needed for location cards
	
		
func load_monster_cards(files):
	for x in files:
		
		var newCard = monsterCardClass.instance()
		
		add_child(newCard)	#if this comes after init() there are some errors with the children being NIL bases
		newCard.init(x, "PlayerOne")
		
		#get_node("Dock").PlaceOtherCard(newCard)
		
				
				
		#connect the card signals
		#this should mean I can connect the signals of loaded/instanced scripts as well in a similar fashion(location, battle etc. cards)
		get_node("Display").ConnectCardSignal(newCard)
		get_node("Dock").PlaceCard(newCard)
		GameState.AddPlayerOneMonsterCard(newCard)
		#more signal connections will be needed for location cards
		
	
func load_playerone_cards(locationCards, monsterCards):
	for x in locationCards:
		
		var newCard = locationCardClass.instance()
		
		add_child(newCard)	#if this comes after init() there are some errors with the children being NIL bases
		newCard.init(x, "PlayerOne")
		
		#get_node("Dock").PlaceOtherCard(newCard)
		
		#connect the card signals
		#this should mean I can connect the signals of loaded/instanced scripts as well in a similar fashion(location, battle etc. cards)
		get_node("Display").ConnectCardSignal(newCard)
		#get_node("Dock").PlaceCard(newCard)
		GameState.AddPlayerOneLocationCard(newCard)
		
	for x in monsterCards:
		
		var newCard = monsterCardClass.instance()
		
		add_child(newCard)	#if this comes after init() there are some errors with the children being NIL bases
		newCard.init(x, "PlayerOne")
		
		#get_node("Dock").PlaceOtherCard(newCard)
				
		#connect the card signals
		#this should mean I can connect the signals of loaded/instanced scripts as well in a similar fashion(location, battle etc. cards)
		get_node("Display").ConnectCardSignal(newCard)
		#get_node("Dock").PlaceCard(newCard)
		GameState.AddPlayerOneMonsterCard(newCard)
		
func load_playertwo_cards(locationCards, monsterCards):
	for x in locationCards:
		
		var newCard = locationCardClass.instance()
		
		add_child(newCard)	#if this comes after init() there are some errors with the children being NIL bases
		newCard.init(x, "PlayerTwo")
		
		#get_node("Dock").PlaceOtherCard(newCard)
				
		#connect the card signals
		#this should mean I can connect the signals of loaded/instanced scripts as well in a similar fashion(location, battle etc. cards)
		get_node("Display").ConnectCardSignal(newCard)
		#get_node("Dock").PlaceCard(newCard)
		GameState.AddPlayerTwoLocationCard(newCard)
		
	for x in monsterCards:
		
		var newCard = monsterCardClass.instance()
		
		add_child(newCard)	#if this comes after init() there are some errors with the children being NIL bases
		newCard.init(x, "PlayerTwo")
		
		#get_node("Dock").PlaceOtherCard(newCard)
				
		#connect the card signals
		#this should mean I can connect the signals of loaded/instanced scripts as well in a similar fashion(location, battle etc. cards)
		get_node("Display").ConnectCardSignal(newCard)
		#get_node("Dock").PlaceCard(newCard)
		GameState.AddPlayerTwoMonsterCard(newCard)
	
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


func _on_End_Turn_pressed():
	
	get_node("Dock").ClearAll()	#wipe the data in card dock
	#in card dock, it seems the values from dicts and the actual values are not the same, this could/will be the source of future problems
	GameState.ClearPlayerCards(GameState.GetCurrentTurn())	#make the unused cards of playerone(the ones that would be in the dock) invisible and unusable
	GameState.ChangeCurrentTurn()
	
	if GameState.GetCurrentTurn() == "PlayerOne":
		get_node("Dock").LoadPlayerCards(GameState.GetPlayerOneUnusedCards())
	else:
		get_node("Dock").LoadPlayerCards(GameState.GetPlayerTwoUnusedCards())
	
