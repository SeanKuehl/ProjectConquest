extends Node2D

var experimentalCardDirectory = "res://Game/Assets/Card Files/experimental/"
#I'd read in all the cards from several folders, all location cards, battle cards etc
var experimentalBaseCardClass = load("res://Game/Scenes/Experimental/Card Experiment.tscn")

var locationCardDirectory = "res://Game/Assets/Card Files/location cards/"
var locationCardClass = load("res://Game/Scenes/Experimental/Location Card.tscn")

var monsterCardDirectory = "res://Game/Assets/Card Files/monster cards/"
var monsterCardClass = load("res://Game/Scenes/Experimental/Monster card.tscn")

var battleCardDirectory = "res://Game/Assets/Card Files/battle cards/"
var battleCardClass = load("res://Game/Scenes/Experimental/Battle card.tscn")


onready var thisNode = get_node(name)

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

var monsterAttackMenuWidth = 1024
var monsterAttackMenuHieght = 600


func _ready():
	get_node("AttackMenu").hide()
	get_node("SkipBattleCardPhase").hide()
	
	GameState.SetLocationDocks(listOfLocationDocks)
	#load_base_card_class(GetFilePathsInDirectory(experimentalCardDirectory))
	#load_location_cards(GetFilePathsInDirectory(locationCardDirectory))
	#load_monster_cards(GetFilePathsInDirectory(monsterCardDirectory))
	load_playerone_cards(GetFilePathsInDirectory(locationCardDirectory), GetFilePathsInDirectory(monsterCardDirectory), GetFilePathsInDirectory(battleCardDirectory))
	load_playertwo_cards(GetFilePathsInDirectory(locationCardDirectory), GetFilePathsInDirectory(monsterCardDirectory), GetFilePathsInDirectory(battleCardDirectory))
	
	#get_tree().change_scene("res://Game/Scenes/Experimental/InGameMenus/MonsterAttackMenu.tscn")
	#get_tree().reload_current_scene()
	
	
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
	#get_tree().change_scene("res://Game/Scenes/Experimental/InGameMenus/MonsterAttackMenu.tscn")
	#get_tree().change_scene("res://Game/Scenes/Experimental/Test root.tscn")
	#get_tree().reload_current_scene()
	#get_tree().get_current_scene().get_node("AttackMenu").hide()
	get_tree().get_current_scene().get_node("AttackMenu").rect_global_position = Vector2(140-(monsterAttackMenuWidth/2),-350-(monsterAttackMenuHieght/2))	#this is apparently the positin of the top left corder
	#1024, 600
	#rect is just top left corner, and it's 1024 wide and 600 tall, so do the math
	
	
func HandleVictory(player):
	get_node("AttackMenu").hide()
	
	var indexOfBattle = GameState.GetindexOfActiveLocationCardDock() + 1	#the usual index in meant for lists, so it starts at zero. But in the scene tree the LocationDock objects start at 1, hence the + 1
	
	get_node("LocationDock"+str(indexOfBattle)).ClearBattleData() 
			
	#remove/clear all active cards and put them into their appropriate used piles
	GameState.PutActiveCardsIntoUsedPiles()
			
	#have monster cards in unused piles restore their original stats
	GameState.RestoreOriginalStatsToUsedMonsterCards()
			
	#restore/set/reset regular turns, clear playerbattle turn
	GameState.RestoreRegularTurnOrder(thisNode)
			
	#award point
	GameState.AwardBattleVictoryPoint(player)
			
	#check for win(later)
			
	#end the battle and set indexes in gamestate
	GameState.RegisterBattleEnded()
	
	
func ShowMonsterAttackOptions(monsterAttackInformation):
	
	#filter the attacks
	
	var filteredAttacks = GameState.FilterMonsterCardAttacks(monsterAttackInformation)
	#every time the user wants to see the attacks they are filtered first
	
	
	
	
	get_node("AttackMenu").LoadMonsterAttacks(filteredAttacks)
	
	#get position of active location card of battle so I can get coords for attack menu
	
	var attackMenuLocation = GameState.GetCenterOfLocationCardDockAtIndex(GameState.GetindexOfActiveLocationCardDock())
	
	#adjust because attack menu places itself based on top left corner and not it's center
	attackMenuLocation.x -= monsterAttackMenuWidth/2
	attackMenuLocation.y -= monsterAttackMenuHieght/2
	
	#hide the location card showing in the dock, otherwise it will draw over the 
	#selection dialogue
	GameState.SetLocationCardAtIndexToHidden(GameState.GetindexOfActiveLocationCardDock())
	
	get_node("AttackMenu").rect_global_position = attackMenuLocation
	get_node("AttackMenu").show()
	
	
func HandleMonsterAttackSelection(chosenFilteredAttack, skipSelected):
	
	if skipSelected:
			GameState.SetLocationCardAtIndexToRevealed(GameState.GetindexOfActiveLocationCardDock())
			get_node("AttackMenu").hide()
			GameState.SetBattleState("BattleCardPhase")	#this phase allows battle cards to be dragged onto location card docks
			#need to make a skip button appear for the user if they want to skip
					#playing a battle card
			print("changed to battle card phase")
	else:
		
		#call monster custom script func
		
		chosenFilteredAttack = GameState.DoMonsterEffectAtCurrentBattleIndex(GameState.GetindexOfActiveLocationCardDock(), chosenFilteredAttack)
		#deal damage to other monster
		
		GameState.DealDamageToOtherMonsterAtCurrentBattleIndex(GameState.GetindexOfActiveLocationCardDock(), chosenFilteredAttack)
		#check for victory
		var victory = GameState.CheckForVictoryAtCurrentBattleIndex(GameState.GetindexOfActiveLocationCardDock())
		#if no victory, change battle state and continue with battle
		if victory == "PlayerOne":	#it works right with turns etc. but it says player one won when they lost, player two won I'm pretty sure
			HandleVictory("PlayerOne")
			
			print("battle was won by player one")
		elif victory == "PlayerTwo":
			
			HandleVictory("PlayerTwo")
			
			print("battle was won by player two")
			
		else:
			#battle continues, switch to battle card phase
			GameState.SetLocationCardAtIndexToRevealed(GameState.GetindexOfActiveLocationCardDock())
			get_node("AttackMenu").hide()
			GameState.SetBattleState("BattleCardPhase")	#this phase allows battle cards to be dragged onto location card docks
			#need to make a skip button appear for the user if they want to skip
					#playing a battle card
			var buttonLocation = GameState.GetCenterOfLocationCardDockAtIndex(GameState.GetindexOfActiveLocationCardDock())
			get_node("SkipBattleCardPhase").rect_global_position.x = buttonLocation.x
			get_node("SkipBattleCardPhase").rect_global_position.y = buttonLocation.y + 100
			get_node("SkipBattleCardPhase").show()
					
			print("changed to battle card phase")
	
	
func HandleFilteredBattleCard(filteredBattleCard, card):
	#[attribute, true]
	
	#if len(filteredBattleCard) == 0, then it's a skip(they pressed the skip button)
	#do the battle card's effect
	if len(filteredBattleCard) == 0:
		#they pressed the skip button
		#now this player's battle turns are over, switch to other player's battle turn
			#this is basically the same as normally switching turns, just using the battle turn instead so I can restore
			#the normal turn order after
			print("it's now the other player's battle turn")
			#use player battle turn not current turn
			get_node("Dock").ClearAll()	#wipe the data in card dock
			#in card dock, it seems the values from dicts and the actual values are not the same, this could/will be the source of future problems
			
			GameState.ClearPlayerCards(GameState.GetPlayerBattleTurn())	#make the unused cards of playerone(the ones that would be in the dock) invisible and unusable
			GameState.ChangePlayerBattleTurn()
			
			if GameState.GetPlayerBattleTurn() == "PlayerOne":
				print(GameState.GetPlayerBattleTurn())
				print("player one is now taking their battle turn")
				get_node("Dock").LoadPlayerCards(GameState.GetPlayerOneUnusedCards())
			else:
				print("player two is now taking their battle turn")
				get_node("Dock").LoadPlayerCards(GameState.GetPlayerTwoUnusedCards())
			
			#add functionality to loadPlayerCards to not mess with cards involved in a battle(may need to set stuff up for this in battle card)
			
			#set the battle state for the next player
			GameState.SetBattleState("MonsterAttackPhase")
			#filter their monster's data before allowing them to progress, same thing 
			var newDataToSet = GameState.FilterMonsterData(GameState.GetPlayerMonsterDataAtCurrentBattleIndex(GameState.GetPlayerBattleTurn()))
			GameState.SetPlayerMonsterDataAtCurrentBattleIndex(GameState.GetPlayerBattleTurn(), newDataToSet)
	else:
	
		card.ActivateEffect(filteredBattleCard)
		
		GameState.AddCardToActiveCardList(card)
		
		#check for victory, the last battle card played may have acheived it
		var victory = GameState.CheckForVictoryAtCurrentBattleIndex(GameState.GetindexOfActiveLocationCardDock())
		
		if victory == "PlayerOne":
			HandleVictory("PlayerOne")
		elif victory == "PlayerTwo":
			HandleVictory("PlayerTwo")
		else:
			
		
		
			#now this player's battle turns are over, switch to other player's battle turn
			#this is basically the same as normally switching turns, just using the battle turn instead so I can restore
			#the normal turn order after
			print("it's now the other player's battle turn")
			#use player battle turn not current turn
			get_node("Dock").ClearAll()	#wipe the data in card dock
			#in card dock, it seems the values from dicts and the actual values are not the same, this could/will be the source of future problems
			
			GameState.ClearPlayerCards(GameState.GetPlayerBattleTurn())	#make the unused cards of playerone(the ones that would be in the dock) invisible and unusable
			GameState.ChangePlayerBattleTurn()
			
			if GameState.GetPlayerBattleTurn() == "PlayerOne":
				print(GameState.GetPlayerBattleTurn())
				print("player one is now taking their battle turn")
				get_node("Dock").LoadPlayerCards(GameState.GetPlayerOneUnusedCards())
			else:
				print("player two is now taking their battle turn")
				get_node("Dock").LoadPlayerCards(GameState.GetPlayerTwoUnusedCards())
			
			#add functionality to loadPlayerCards to not mess with cards involved in a battle(may need to set stuff up for this in battle card)
			
			#set the battle state for the next player
			GameState.SetBattleState("MonsterAttackPhase")
			#filter their monster's data before allowing them to progress, same thing 
			var newDataToSet = GameState.FilterMonsterData(GameState.GetPlayerMonsterDataAtCurrentBattleIndex(GameState.GetPlayerBattleTurn()))
			GameState.SetPlayerMonsterDataAtCurrentBattleIndex(GameState.GetPlayerBattleTurn(), newDataToSet)
	
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
		
	
func load_playerone_cards(locationCards, monsterCards, battleCards):
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
		
	for x in battleCards:
		
		var newCard = battleCardClass.instance()
		
		add_child(newCard)	#if this comes after init() there are some errors with the children being NIL bases
		newCard.init(x, "PlayerOne")
		
		#get_node("Dock").PlaceOtherCard(newCard)
		
		#connect the card signals
		#this should mean I can connect the signals of loaded/instanced scripts as well in a similar fashion(location, battle etc. cards)
		get_node("Display").ConnectCardSignal(newCard)
		#get_node("Dock").PlaceCard(newCard)
		GameState.AddPlayerOneBattleCard(newCard)
		
func load_playertwo_cards(locationCards, monsterCards, battleCards):
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
		
	for x in battleCards:
		
		var newCard = battleCardClass.instance()
		
		add_child(newCard)	#if this comes after init() there are some errors with the children being NIL bases
		newCard.init(x, "PlayerTwo")
		
		#get_node("Dock").PlaceOtherCard(newCard)
				
		#connect the card signals
		#this should mean I can connect the signals of loaded/instanced scripts as well in a similar fashion(location, battle etc. cards)
		get_node("Display").ConnectCardSignal(newCard)
		#get_node("Dock").PlaceCard(newCard)
		GameState.AddPlayerTwoBattleCard(newCard)
	
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
	


func _on_SkipBattleCardPhase_pressed():
	HandleFilteredBattleCard([], [])
	
	#now hide the button
	
	get_node("SkipBattleCardPhase").hide()
