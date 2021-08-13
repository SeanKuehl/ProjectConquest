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


func _ready():
	
	#load_base_card_class(GetFilePathsInDirectory(experimentalCardDirectory))
	#load_location_cards(GetFilePathsInDirectory(locationCardDirectory))
	load_monster_cards(GetFilePathsInDirectory(monsterCardDirectory))
	
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
