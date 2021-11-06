extends Control



var savedDecksDirectory = "res://Game/Assets/SavedDecksFolder/"

var listOfDecks = []

var numberOfTimesNextPressed = 0

func _ready():


	#if this menu is being used by the players to select their decks,
	#set the designated label to tell them
	if DeckMenuHelper.GetPlayersSelectingDecksForBattle():
		#tell player whose turn it is to select deck for battle
		if GameState.GetSetADeckFirstTime():
			#it's player one's turn


			$WhoIsSelectingDeck.text = "Player ONE please select your deck"

		else:

			$WhoIsSelectingDeck.text = "Player TWO please select your deck"


	Settings.SetButtonToTheme($LastButton)
	Settings.SetButtonToTheme($NextButton)
	Settings.SetButtonToTheme($DeckButton1)
	Settings.SetButtonToTheme($DeckButton2)
	Settings.SetButtonToTheme($DeckButton3)
	Settings.SetButtonToTheme($DeckButton4)
	Settings.SetButtonToTheme($CreateNewDeckButton)
	Settings.SetButtonToTheme($BackButton)
	Settings.SetPanelToTheme($Panel)


	var returnedVals = MusicManager.GetCurrentMenuMusic()	#first is music, second is position in song
	var song = returnedVals[0]
	var songPos = returnedVals[1]
	$MenuMusic.stream = song
	$MenuMusic.play(songPos)

	listOfDecks = GetFilePathsInDirectory(savedDecksDirectory)	#load decks
	#deckName = deckName[0]
	#deckName.erase(0, len(savedDecksDirectory))	#this is how you get just the name, erase doesn't return though(it returns void)
	DisplayDecks()

func DisplayDecks():

	#if there are no decks, hide the buttons or don't do anything
	var startingDeckDisplayIndex = 1
	var maxDeckDisplayIndex = 4
	if len(listOfDecks) <= maxDeckDisplayIndex:
		for x in range(startingDeckDisplayIndex,len(listOfDecks)+1):
			#max is exclusive
			var tempDeck = listOfDecks[x-1]	#listOfDecks starts at zero, so -1
			tempDeck.erase(0, len(savedDecksDirectory))
			get_node("DeckButton"+str(x)).text = tempDeck
	elif len(listOfDecks) > maxDeckDisplayIndex:
		var startingIndex = startingDeckDisplayIndex + (numberOfTimesNextPressed * maxDeckDisplayIndex)
		var index = 1

		for x in range(startingIndex, startingIndex+maxDeckDisplayIndex+1):
			#+1 because max is inclusive

			if (x-1) < (len(listOfDecks)) and index <= maxDeckDisplayIndex:

				var tempDeck = listOfDecks[x-1]	#listOfDecks starts at zero, so -1
				tempDeck.erase(0, len(savedDecksDirectory))
				get_node("DeckButton"+str(index)).text = tempDeck
				index += 1
			elif (x-1) > (len(listOfDecks)) and index <= maxDeckDisplayIndex:
				#clear the button text

				get_node("DeckButton"+str(index)).text = ""	#must be this otherwise it will try and use it
				index += 1
			else:
				pass

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


func ReadLinesFromFile(fileName):
	var file = File.new()
	file.open(fileName, File.READ)
	var content = []
	#check for empty lines! reading etc the file will add an empty line onto the end of it
	var line = ""
	while file.eof_reached() == false:
		line = file.get_line()
		if line == "":
			#it's an empty line, ignore it
			pass
		else:
			content.append(line)

	file.close()

	return content


func SwitchToEditDeckMenuIfApplicable(button):
	var deckName = button.text

	if deckName == "":
		#it's empty, no deck to edit
		pass
	else:
		#it has a deckName, add the directory back on to get the file's data and pass
		#the deck on the file to the next menu so it can be edited(via deckmenuhelper global)
		DeckMenuHelper.SetDeckName(deckName)
		deckName = savedDecksDirectory + deckName
		var fileContent = ReadLinesFromFile(deckName)

		#first 5 are location cards, next 5 monster, next 5 battle, next 5 strategy
		var locations = []
		var monsters = []
		var battles = []
		var strategys = []

		var startIndex = 0
		var stopIndex = 4
		for x in range(startIndex, stopIndex+1):
			#max is exclusive
			locations.append(fileContent[x])

		startIndex += 5
		stopIndex += 5

		for x in range(startIndex, stopIndex+1):
			#max is exclusive
			monsters.append(fileContent[x])

		startIndex += 5
		stopIndex += 5

		for x in range(startIndex, stopIndex+1):
			#max is exclusive
			battles.append(fileContent[x])

		startIndex += 5
		stopIndex += 5

		for x in range(startIndex, stopIndex+1):
			#max is exclusive
			strategys.append(fileContent[x])


		DeckMenuHelper.SetDeck(locations, monsters, battles, strategys)
		get_tree().change_scene("res://Game/Scenes/Main/DeckMenus/EditDecksMenu.tscn")

func PlayerSelectedDeck(button):
	var deckName = button.text

	if deckName == "":
		#it's empty, no deck to edit
		pass
	else:
		#it has a deckName, add the directory back on to get the file's data and pass
		#the deck on the file to the next menu so it can be edited(via deckmenuhelper global)
		DeckMenuHelper.SetDeckName(deckName)
		deckName = savedDecksDirectory + deckName
		var fileContent = ReadLinesFromFile(deckName)

		#first 5 are location cards, next 5 monster, next 5 battle, next 5 strategy
		var locations = []
		var monsters = []
		var battles = []
		var strategys = []

		var startIndex = 0
		var stopIndex = 4
		for x in range(startIndex, stopIndex+1):
			#max is exclusive
			locations.append(fileContent[x])

		startIndex += 5
		stopIndex += 5

		for x in range(startIndex, stopIndex+1):
			#max is exclusive
			monsters.append(fileContent[x])

		startIndex += 5
		stopIndex += 5

		for x in range(startIndex, stopIndex+1):
			#max is exclusive
			battles.append(fileContent[x])

		startIndex += 5
		stopIndex += 5

		for x in range(startIndex, stopIndex+1):
			#max is exclusive
			strategys.append(fileContent[x])


		if GameState.GetSetADeckFirstTime() == false:
			GameState.SetADeck(locations, monsters, battles, strategys)	#first time it will set player one deck, second time player two's
			get_tree().change_scene("res://Game/Scenes/Main/Root.tscn")
		else:
			GameState.SetADeck(locations, monsters, battles, strategys)	#first time it will set player one deck, second time player two's
			get_tree().change_scene("res://Game/Scenes/Main/DeckMenus/DisplayDecksMenu.tscn")


func _on_DeckButton1_pressed():
	MusicManager.SetMenuMusicPlaybackPosition($MenuMusic.get_playback_position())

	#put an if statement here, if a global variable is true, when they click they select a deck
	if DeckMenuHelper.GetPlayersSelectingDecksForBattle():
		PlayerSelectedDeck($DeckButton1)
	else:
		SwitchToEditDeckMenuIfApplicable($DeckButton1)


func _on_DeckButton3_pressed():
	MusicManager.SetMenuMusicPlaybackPosition($MenuMusic.get_playback_position())

	if DeckMenuHelper.GetPlayersSelectingDecksForBattle():
		PlayerSelectedDeck($DeckButton3)
	else:
		SwitchToEditDeckMenuIfApplicable($DeckButton3)



func _on_DeckButton4_pressed():
	MusicManager.SetMenuMusicPlaybackPosition($MenuMusic.get_playback_position())

	if DeckMenuHelper.GetPlayersSelectingDecksForBattle():
		PlayerSelectedDeck($DeckButton4)
	else:
		SwitchToEditDeckMenuIfApplicable($DeckButton4)



func _on_DeckButton2_pressed():
	MusicManager.SetMenuMusicPlaybackPosition($MenuMusic.get_playback_position())

	if DeckMenuHelper.GetPlayersSelectingDecksForBattle():
		PlayerSelectedDeck($DeckButton2)
	else:
		SwitchToEditDeckMenuIfApplicable($DeckButton2)



func _on_CreateNewDeckButton_pressed():
	MusicManager.SetMenuMusicPlaybackPosition($MenuMusic.get_playback_position())

	if DeckMenuHelper.GetPlayersSelectingDecksForBattle():
		pass
	else:

		DeckMenuHelper.SetDeckName("")	#clear the current deck name
		DeckMenuHelper.SetDeck([], [], [], [])	#clear the working deck
		get_tree().change_scene("res://Game/Scenes/Main/DeckMenus/EditDecksMenu.tscn")



func _on_BackButton_pressed():
	MusicManager.SetMenuMusicPlaybackPosition($MenuMusic.get_playback_position())

	if DeckMenuHelper.GetPlayersSelectingDecksForBattle():
		pass
	else:
		get_tree().change_scene("res://Game/Scenes/Main/MainMenuAndSubMenus/MainMenu.tscn")


func _on_NextButton_pressed():
	var maxNumberOfDecks = 4
	if numberOfTimesNextPressed >= len(listOfDecks)/maxNumberOfDecks:
		pass
	else:
		numberOfTimesNextPressed += 1
		DisplayDecks()


func _on_LastButton_pressed():
	if numberOfTimesNextPressed == 0:
		pass
	else:
		numberOfTimesNextPressed -= 1
		DisplayDecks()
