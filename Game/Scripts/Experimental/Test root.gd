extends Node2D

var experimentalCardDirectory = "res://Game/Assets/Card Files/"
#I'd read in all the cards from several folders, all location cards, battle cards etc
var experimentalBaseCardClass = load("res://Game/Scenes/Experimental/Card Experiment.tscn")


func _ready():
	#load the one card into the scene by reading the card's text file from directory
	var fileNames = list_files_in_directory(experimentalCardDirectory)
	var filePaths = []
	#to read from the file, it will need the full path to the file
	for x in fileNames:
		filePaths.append(experimentalCardDirectory+x)
		
	load_base_card_class(filePaths)
	
func load_base_card_class(files):
	for x in files:
		for y in range(5):
			#this y loop is temp just to have more card to test the card dock with
			var newCard = experimentalBaseCardClass.instance()
			add_child(newCard)	#if this comes after init() there are some errors with the children being NIL bases
			newCard.init(x, "PlayerOne")
			
			#connect the card signals
			#this should mean I can connect the signals of loaded/instanced scripts as well in a similar fashion(location, battle etc. cards)
			get_node("Display").ConnectCardSignal(newCard)
		
		
	
		
	
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
