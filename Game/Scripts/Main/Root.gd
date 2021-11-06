extends Node2D



var locationCardDirectory = "res://Game/Assets/Card Files/location cards/"
var locationCardClass = load("res://Game/Scenes/Main/Cards/Location Card.tscn")

var monsterCardDirectory = "res://Game/Assets/Card Files/monster cards/"
var monsterCardClass = load("res://Game/Scenes/Main/Cards/Monster card.tscn")

var battleCardDirectory = "res://Game/Assets/Card Files/battle cards/"
var battleCardClass = load("res://Game/Scenes/Main/Cards/Battle card.tscn")

var strategyCardDirectory = "res://Game/Assets/Card Files/strategy cards/"
var strategyCardClass = load("res://Game/Scenes/Main/Cards/Strategy Card.tscn")

onready var thisNode = get_tree().get_current_scene()

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

#monster attack menu and strategy card menu are the same size
var strategyCardMenuWidth = 1024
var strategyCardMenuHieght = 600

#victory screen menu is the same size as the other two
var victoryMenuWidth = 1024
var victoryMenuHieght = 600

var strategyCardBeingHandled = 0
var locationDockNumbersList = []	#this temporarily stores the values of location dock indexes that will be handed off to game state for use in the strategy card's script

var battleMusicOn = false

var playerWhoWon = ""	#this works with the GameState Victory bool so the player has to end their turn after a battle is won

var musicPaused = false

func _ready():
	#hide these menus, they'll be made visible only when the user needs to use them
	#get_node("AttackMenu").hide()

	#apply the universal button theme to the "end phase" button
	Settings.SetButtonToTheme($"End Phase")

	get_node("Display").ConnectHelpSignal(get_node("HelpButton"))

	get_node("VictoryScreen").hide()

	get_node("StrategyCardMenu").connect("userMadeSelection", self, "UserSelectedFromStrategyCardMenu")
	get_node("StrategyCardMenu").HideMyStuff()

	GameState.SetLocationDocks(listOfLocationDocks)	#set the game state reference lists to the location docks on the field of play

	#load_playerone_cards(GetFilePathsInDirectory(locationCardDirectory), GetFilePathsInDirectory(monsterCardDirectory), GetFilePathsInDirectory(battleCardDirectory), GetFilePathsInDirectory(strategyCardDirectory))
	#load_playertwo_cards(GetFilePathsInDirectory(locationCardDirectory), GetFilePathsInDirectory(monsterCardDirectory), GetFilePathsInDirectory(battleCardDirectory), GetFilePathsInDirectory(strategyCardDirectory))
	#GameState.GetADeck("Location", "PlayerOne")
	load_playerone_cards(GameState.GetADeck("Location", "PlayerOne"), GameState.GetADeck("Monster", "PlayerOne"), GameState.GetADeck("Battle", "PlayerOne"), GameState.GetADeck("Strategy", "PlayerOne"))
	load_playertwo_cards(GameState.GetADeck("Location", "PlayerTwo"), GameState.GetADeck("Monster", "PlayerTwo"), GameState.GetADeck("Battle", "PlayerTwo"), GameState.GetADeck("Strategy", "PlayerTwo"))


	GameState.SetTurnState("Setup")


	GameState.ClearPlayerCards("PlayerTwo")	#it's player one's turn first



	get_node("Dock").LoadPlayerCards(GameState.GetPlayerOneUnusedCards())

	#this is temporary for a test
	#GameState.MoveLocationCardToAndFromUsedPile()
	#GameState.MovingCardsFromUsedPilesTest()

	#it's now a canvas layer, position isn't needed
	#var centerOfMiddleLocationDockX = 140
	#var centerOfMiddleLocationDockY = -350
	#get_node("AttackMenu").rect_global_position = Vector2(centerOfMiddleLocationDockX-(monsterAttackMenuWidth/2),centerOfMiddleLocationDockY-(monsterAttackMenuHieght/2))	#rect_global_position is apparently the positin of the top left corder
	#1024, 600
	#rect is just top left corner, and it's 1024 wide and 600 tall, so do the math

func ToggleMusicPaused(val):
	musicPaused = val

#this is for gamestate using card effects
func CallLoadPlayerCardsFromGameState(cards):
	#get_node("Dock").ClearAll()	#this is needed to get rid of the reference to the recently removed card from unused pile, many card effects using this func handle that
	get_node("Dock").LoadPlayerCards(cards)



func ShowFullScreenInGameMenu():
	get_node("FullScreenInGameMenu").ShowMyStuff()

func ShowCardActivationScreen(cardColor, cardType, cardName):
	get_node("CardActivationScreen").DisplayCard(cardColor, cardType, cardName)

func StopBattleMusic():
	$GameMusic.stop()
	battleMusicOn = false


func _physics_process(_delta):

	#there is a game state function that calls a func here to make the music stop
	#playing once battle is done so this should work

	if musicPaused:
		$GameMusic.stop()

	elif GameState.GetBattleState() == "" and $GameMusic.is_playing() == false:
		#there is no battle going on and no music is playing
		#stop the last music
		$GameMusic.stop()

		#play a new game music
		$GameMusic.stream = MusicManager.GetGameMusic()
		$GameMusic.play()



	elif GameState.GetBattleState() != "" and $GameMusic.is_playing() == true and battleMusicOn == false:
		#if there is a battle and the game music is still playing
		#stop it and start some battle music
		$GameMusic.stop()

		battleMusicOn = true

		#play a new battle music
		$GameMusic.stream = MusicManager.GetBattleMusic()

		$GameMusic.play()



#player is either "PlayerOne" or "PlayerTwo" and indicates which player won the battle
#this function handles a player winning a battle, including shutting down the battle/putting away assets used in battle
func HandleVictory(player):
	get_node("AttackMenu").HideMyStuff()

	var indexOfBattle = GameState.GetindexOfActiveLocationCardDock() + 1	#the usual index in meant for lists, so it starts at zero. But in the scene tree the LocationDock objects start at 1, hence the + 1

	get_node("LocationDock"+str(indexOfBattle)).ClearBattleData() 	#this assumes the location docks are names "LocationDock1"-"LocationDock9"

	#remove/clear all active cards and put them into their appropriate used piles(active cards are battle and location cards)
	GameState.PutActiveCardsIntoUsedPiles()

	#put monster cards into used piles(the only kind of card that is involved in battle that is not counted as active)
	GameState.PutMonsterCardsIntoUsedPiles()

	#have monster cards in used piles restore their original stats, in case they are brought back later to be used again
	GameState.RestoreOriginalStatsToUsedMonsterCards()

	#restore/set/reset regular turns, clear playerbattle turn
	#thisNode is a reference to the root node
	GameState.RestoreRegularTurnOrder(thisNode)

	#award point for winning the battle
	GameState.AwardBattleVictoryPoint(player, thisNode)

	GameState.SetVictory(false)

	#end the battle and set indexes in gamestate
	GameState.RegisterBattleEnded()


#caller is either "first time" if it is being called for the first time from a function in location card dock or
#"signal" if it is being called because the user gave input to a strategy card menu
#this function calls the currently being handled strategy card's preperation function and stores the input
#until it recieves the "Done" return value that there is no more preperation, at which point
#it passed the stored values to game state and calls the appropriate function to handle the strategy card's effect
#NOTE: this function is called by the signal sent when the strategy card menu recieves input (hence the "signal" caller)

func UserSelectedFromStrategyCardMenu(caller):
	#this could either be called for the first time, or from the signal

	if caller == "first time":

		var possibleDone = strategyCardBeingHandled.ActivatePreparation()

		#this happens if the card has no preparation and just returns "Done" on the first call
		if possibleDone == "Done":
			ShowCardActivationScreen(strategyCardBeingHandled.GetColorBackgroundColor(), strategyCardBeingHandled.GetCardType(), strategyCardBeingHandled.GetCardName())
			GameState.SetStrategyPreparationValues(locationDockNumbersList)

			get_node("LocationDock1").StrategyCardActivateEffectHelperCode(strategyCardBeingHandled)	#it doesn't matter which dock executes this function since nothing is stored in location dock


		locationDockNumbersList = []	#clear it incase this is no the first strategy card played
	elif caller == "signal":
		#close the last menu
		get_node("StrategyCardMenu").SetTextToShowUser("")
		get_node("StrategyCardMenu").HideMyStuff()

		var dockNum = get_node("StrategyCardMenu").GetLocationDockToReturn()
		get_node("StrategyCardMenu").SetLocationDockToReturn(-1)	#reset it for next time, -1 is good here because it's not a valid dock index so if it were returned when it shouldn't be it would throw an error

		locationDockNumbersList.append(dockNum)


		#keep calling preparation until we get "done"
		var possibleDone = strategyCardBeingHandled.ActivatePreparation()


		if possibleDone == "Done":
			ShowCardActivationScreen(strategyCardBeingHandled.GetColorBackgroundColor(), strategyCardBeingHandled.GetCardType(), strategyCardBeingHandled.GetCardName())
			GameState.SetStrategyPreparationValues(locationDockNumbersList)

			get_node("LocationDock1").StrategyCardActivateEffectHelperCode(strategyCardBeingHandled)	#it doesn't matter which dock executes this function since nothing is stored in location dock


#card is a reference to a strategy card
func SetStrategyCardBeingHandled(card):
	strategyCardBeingHandled = card

func GetStrategyCardBeingHandled():
	return strategyCardBeingHandled

func HandleActiveCardEffectsMenu():
	get_node("ActiveEffectsMenu").ShowMyStuff()

func HandleVictoryMenu(victoriousPlayer):
	var menuLocation = GameState.GetCenterOfLocationCardDockAtIndex(5)	#the 5th location dock is the one in the middle


	#I don't know why this doesn't get the right thing(centered) but I think
	#monster attack menu had something additional for it's position in ready()
	menuLocation.x -= victoryMenuWidth
	menuLocation.y -= victoryMenuHieght/2

	#this is a big menu that goes over most if not all location card docks
	#if the location docks are revealed they will go over th menu, hide them to avoid this
	#there are nine location card docks stored in a list(starts at 0)
	for x in range(0,9):
		#max is exclusive
		GameState.SetLocationCardAtIndexToHidden(x)

	get_node("VictoryScreen").SetWhoWon(victoriousPlayer)
	get_node("VictoryScreen").rect_global_position = menuLocation
	get_node("VictoryScreen").show()


#monsterAttackInformation is a list of monster attacks, each monster attack is in this format:
#[1, "flaming Sting", 60, "Inferno", "there is a one in eight chance this attack does 100 damage", true, true]
#where the the information is: the index of the attack(first attack), name of the attack, damage of the attack, attribute of the attack, text effect of the attack, whether the effect is enabled, whether the attack is allowed
#this function filters, loads and displays the monster attacks to the user
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

	#get_node("AttackMenu").rect_global_position = attackMenuLocation
	get_node("AttackMenu").ShowMyStuff()

#switch battle state phases to battle card phase and show the skip button in case they don't want
#to play a battle card this battle turn
func SwitchToBattleCardPhase():
	GameState.SetLocationCardAtIndexToRevealed(GameState.GetindexOfActiveLocationCardDock())
	get_node("AttackMenu").HideMyStuff()

	GameState.SetBattleState("BattleCardPhase")	#this phase allows battle cards to be dragged onto location card docks


	#GameState.SetBattleState("BattleCardPhase")	#this phase allows battle cards to be dragged onto location card docks



#chosenFilteredAttack is a monster attack that's been filtered by all active cards(see ShowMonsterAttackOptions(monsterAttackInformation))
#it is in the form: [1, "flaming Sting", 60, "Inferno", "there is a one in eight chance this attack does 100 damage", true, true]
#skipSelected is a bool which indicates whether or not the player pressed the button to skip their attack this turn
#this function handles the selection the player made on the monster attack menu by handling the attack
#if one was selected as well as checking for and handling victory if the attack won the battle. It also switches phases where needed
func HandleMonsterAttackSelection(chosenFilteredAttack, skipSelected):

	if skipSelected:
		SwitchToBattleCardPhase()
	else:

		#call monster custom script func
		chosenFilteredAttack = GameState.DoMonsterEffectAtCurrentBattleIndex(GameState.GetindexOfActiveLocationCardDock(), chosenFilteredAttack)

		#deal damage to other monster
		GameState.DealDamageToOtherMonsterAtCurrentBattleIndex(GameState.GetindexOfActiveLocationCardDock(), chosenFilteredAttack)

		#check for victory
		var victory = GameState.CheckForVictoryAtCurrentBattleIndex(GameState.GetindexOfActiveLocationCardDock())

		if victory == "PlayerOne":
			GameState.SetVictory(true)
			playerWhoWon = "PlayerOne"


		elif victory == "PlayerTwo":
			GameState.SetVictory(true)
			playerWhoWon = "PlayerTwo"


		else:
			#if no victory battle continues, switch to battle card phase
			SwitchToBattleCardPhase()

#filteredBattleCard, this is the info of a battle card after it's been filtered by all other active cards
#it's in the form: [attribute, true] where the 'true' is a bool representing whether or not the card is allowed to be played
#card, this is a reference to the actual battle card to whom the filteredBattleCard information belongs
#this function checks whether or not the player skipped their battle card phase, and handles the outcomes
#whether they skipped or played a card, if they played a card it will add that card to the list of active cards
#and check for victory(some battle cards may do damage)
func HandleFilteredBattleCard(filteredBattleCard, card):



	if len(filteredBattleCard) == 0:
		#they pressed the skip button
		#now this player's battle turns are over, switch to other player's battle turn
			#this is basically the same as normally switching turns, just using the battle turn instead so I can restore
			#the normal turn order after
			FilterCurrentPlayerMonsterData()

			EndCurrentPlayerBattleTurn()


			#set the battle state for the next player
			GameState.SetBattleState("MonsterAttackPhase")

			#filter (other player's) their monster's data before showing it
			FilterCurrentPlayerMonsterData()


	else:
		ShowCardActivationScreen(card.GetColorBackgroundColor(), card.GetCardType(), card.GetCardName())
		#they played a card, handle it's effect
		card.ActivateEffect(filteredBattleCard)

		GameState.AddCardToActiveCardList(card)

		#check for victory, the last battle card played may have acheived it
		var victory = GameState.CheckForVictoryAtCurrentBattleIndex(GameState.GetindexOfActiveLocationCardDock())

		if victory == "PlayerOne":
			GameState.SetVictory(true)
			playerWhoWon = "PlayerOne"

		elif victory == "PlayerTwo":
			GameState.SetVictory(true)
			playerWhoWon = "PlayerTwo"

		else:
			#no one won, continue the battle


			#now this player's battle turns are over, switch to other player's battle turn
			#this is basically the same as normally switching turns, just using the battle turn instead so I can restore
			#the normal turn order after



			FilterCurrentPlayerMonsterData()

			EndCurrentPlayerBattleTurn()


			#set the battle state for the next player
			GameState.SetBattleState("MonsterAttackPhase")

			#filter (other player's) their monster's data before allowing them to progress, same thing
			#filter both player's monster data in case the battle card changed anything
			FilterCurrentPlayerMonsterData()
			#I tried one func which does both players but it didn't work, things need it to be the right player's turn to work


func FilterCurrentPlayerMonsterData():
	var newDataToSet = GameState.FilterMonsterData(GameState.GetPlayerMonsterDataAtCurrentBattleIndex(GameState.GetPlayerBattleTurn()))
	GameState.SetPlayerMonsterDataAtCurrentBattleIndex(GameState.GetPlayerBattleTurn(), newDataToSet)




#dir is the path to a dictory
#this function takes a directory and returns the full paths to files, ["c:/hello.txt"] for example
func GetFilePathsInDirectory(dir):

	var fileNames = list_files_in_directory(dir)
	var filePaths = []
	#to read from the file, it will need the full path to the file
	for x in fileNames:
		filePaths.append(dir+x)

	return filePaths


#locationCards, all the text files in the locationCardsDirectory
#monsterCards, all the text files in the monsterCardsDirectory
#battleCards, all the text files in the battleCardsDirectory
#strategyCards, all the text files in the strategyCardsDirectory
#this function takes the text files with the information for the cards and
#uses them to create nodes and loads them into the root scene as a child
#with the text file information. Load all cards for player one
func load_playerone_cards(locationCards, monsterCards, battleCards, strategyCards):

	for x in locationCards:

		var newCard = locationCardClass.instance()

		add_child(newCard)	#if this comes after init() there are some errors with the children being NIL bases
		newCard.init(x, "PlayerOne")



		#connect the card signals

		get_node("Display").ConnectCardSignal(newCard)

		GameState.AddPlayerOneLocationCard(newCard)

	for x in monsterCards:

		var newCard = monsterCardClass.instance()

		add_child(newCard)	#if this comes after init() there are some errors with the children being NIL bases
		newCard.init(x, "PlayerOne")



		#connect the card signals

		get_node("Display").ConnectCardSignal(newCard)

		GameState.AddPlayerOneMonsterCard(newCard)

	for x in battleCards:

		var newCard = battleCardClass.instance()

		add_child(newCard)	#if this comes after init() there are some errors with the children being NIL bases
		newCard.init(x, "PlayerOne")



		#connect the card signals

		get_node("Display").ConnectCardSignal(newCard)

		GameState.AddPlayerOneBattleCard(newCard)

	for x in strategyCards:
		var newCard = strategyCardClass.instance()

		add_child(newCard)	#if this comes after init() there are some errors with the children being NIL bases
		newCard.init(x, "PlayerOne")



		#connect the card signals

		get_node("Display").ConnectCardSignal(newCard)

		GameState.AddPlayerOneStrategyCard(newCard)








#locationCards, all the text files in the locationCardsDirectory
#monsterCards, all the text files in the monsterCardsDirectory
#battleCards, all the text files in the battleCardsDirectory
#strategyCards, all the text files in the strategyCardsDirectory
#this function takes the text files with the information for the cards and
#uses them to create nodes and loads them into the root scene as a child
#with the text file information. Load all cards for player two
func load_playertwo_cards(locationCards, monsterCards, battleCards, strategyCards):
	for x in locationCards:

		var newCard = locationCardClass.instance()

		add_child(newCard)	#if this comes after init() there are some errors with the children being NIL bases
		newCard.init(x, "PlayerTwo")



		#connect the card signals

		get_node("Display").ConnectCardSignal(newCard)

		GameState.AddPlayerTwoLocationCard(newCard)

	for x in monsterCards:

		var newCard = monsterCardClass.instance()

		add_child(newCard)	#if this comes after init() there are some errors with the children being NIL bases
		newCard.init(x, "PlayerTwo")



		#connect the card signals

		get_node("Display").ConnectCardSignal(newCard)

		GameState.AddPlayerTwoMonsterCard(newCard)

	for x in battleCards:

		var newCard = battleCardClass.instance()

		add_child(newCard)	#if this comes after init() there are some errors with the children being NIL bases
		newCard.init(x, "PlayerTwo")



		#connect the card signals

		get_node("Display").ConnectCardSignal(newCard)

		GameState.AddPlayerTwoBattleCard(newCard)

	for x in strategyCards:
		var newCard = strategyCardClass.instance()

		add_child(newCard)	#if this comes after init() there are some errors with the children being NIL bases
		newCard.init(x, "PlayerTwo")



		#connect the card signals

		get_node("Display").ConnectCardSignal(newCard)

		GameState.AddPlayerTwoStrategyCard(newCard)


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


#card, this is a reference to a card
func PutCardBackInDock(card):
	get_node("Dock").PlaceCard(card)


#text, this is the message that will be  the prompt for the user to select a location dock from the strategy card menu
#this function sets the position of and shows the strategy card menu with the needed information
#NOTE: this is called as the end of a chain that starts in the preperation function of the custom script
#of a strategy card
func HandleStrategyCardMenu(text):

	var menuLocation = GameState.GetCenterOfLocationCardDockAtIndex(5)	#the 5th location dock is the one in the middle


	#I don't know why this doesn't get the right thing(centered) but I think
	#monster attack menu had something additional for it's position in ready()
	menuLocation.x -= strategyCardMenuWidth
	menuLocation.y -= strategyCardMenuHieght/2

	#this is a big menu that goes over most if not all location card docks
	#if the location docks are revealed they will go over th menu, hide them to avoid this
	#there are nine location card docks stored in a list(starts at 0)
	for x in range(0,9):
		#max is exclusive
		GameState.SetLocationCardAtIndexToHidden(x)

	get_node("StrategyCardMenu").SetTextToShowUser(text)
	#get_node("StrategyCardMenu").rect_global_position = menuLocation
	get_node("StrategyCardMenu").ShowMyStuff()



func EndCurrentPlayerTurn():

	get_node("Dock").ClearAll()	#wipe the data in card dock

	GameState.ClearPlayerCards(GameState.GetCurrentTurn())	#make the unused cards of the current player(the ones that would be in the dock) invisible and unusable
	GameState.ChangeCurrentTurn()

	get_node("Dock").SetButtonHighlightToDefault()
	get_node("Display").ClearDisplay()

	get_node("TurnTransitionMenu").SetWhoseTurnNext(GameState.GetCurrentTurn())
	get_node("TurnTransitionMenu").ShowMyStuff()

	if GameState.GetCurrentTurn() == "PlayerOne":
		get_node("Dock").LoadPlayerCards(GameState.GetPlayerOneUnusedCards())
	else:
		get_node("Dock").LoadPlayerCards(GameState.GetPlayerTwoUnusedCards())






func EndCurrentPlayerBattleTurn():
	#use player battle turn not current turn

	get_node("Dock").ClearAll()	#wipe the data in card dock


	GameState.ClearPlayerCards(GameState.GetPlayerBattleTurn())	#make the unused cards of playerone(the ones that would be in the dock) invisible and unusable
	GameState.ChangePlayerBattleTurn()

	get_node("Dock").SetButtonHighlightToDefault()
	get_node("Display").ClearDisplay()

	get_node("TurnTransitionMenu").SetWhoseTurnNext(GameState.GetPlayerBattleTurn())
	get_node("TurnTransitionMenu").ShowMyStuff()

	if GameState.GetPlayerBattleTurn() == "PlayerOne":
		get_node("Dock").LoadPlayerCards(GameState.GetPlayerOneUnusedCards())
	else:
		get_node("Dock").LoadPlayerCards(GameState.GetPlayerTwoUnusedCards())


func RefreshCards():
	#this addresses a problem where if you left a card out of the dock it
	#would remain like that through the different phases and could cause problems
	if GameState.GetThereIsActiveBattle():
		GameState.ClearPlayerCards(GameState.GetPlayerBattleTurn())

		if GameState.GetPlayerBattleTurn() == "PlayerOne":
			get_node("Dock").LoadPlayerCards(GameState.GetPlayerOneUnusedCards())
		else:
			get_node("Dock").LoadPlayerCards(GameState.GetPlayerTwoUnusedCards())
	else:
		GameState.ClearPlayerCards(GameState.GetCurrentTurn())

		if GameState.GetCurrentTurn() == "PlayerOne":
			get_node("Dock").LoadPlayerCards(GameState.GetPlayerOneUnusedCards())
		else:
			get_node("Dock").LoadPlayerCards(GameState.GetPlayerTwoUnusedCards())



func NotifyThatTurnHasEnded():

	get_node("CardActivationScreen").SetEndTurnNotification()
	get_node("CardActivationScreen").ShowMyStuff()


func _on_End_Phase_pressed():
	if GameState.GetTurnState() == "Setup" and GameState.GetTurnOver() == true:
		if GameState.GetCurrentTurn() == "PlayerTwo":
			GameState.ChangeTurnState()	#from setup phase, it will change to location card phase
			RefreshCards()

		EndCurrentPlayerTurn()
		GameState.SetTurnOver(false)
		NotifyThatTurnHasEnded()
		RefreshCards()

	elif GameState.GetVictory() == true:
		HandleVictory(playerWhoWon)	#Victory is set to false inside this function
		playerWhoWon = ""



	elif GameState.GetThereIsActiveBattle():
		#you can't change turn phase during a battle, unless it's the battle card phase, the monster attack phase has a different skip button

		if GameState.GetBattleState() == "BattleCardPhase":
			NotifyThatTurnHasEnded()
			RefreshCards()
			#the first argument having a length of 0 is what the function will use to determine that the user has pressed the skip button
			HandleFilteredBattleCard([], [])	#this will trigger the turns to change
			#this replaces the skip battle card phase button


	elif GameState.GetTurnState() == "MonsterCardPhase":
		NotifyThatTurnHasEnded()
		RefreshCards()
		#don't need to check for turn over because player doesn't have to play a card here
		GameState.ChangeTurnState()
		GameState.SetTurnOver(false)

	elif GameState.GetTurnState() == "StrategyCardPhase":
		NotifyThatTurnHasEnded()
		RefreshCards()
		#don't need to check for turn over because player doesn't have to play a card here
		GameState.ChangeTurnState()
		GameState.SetTurnOver(false)	#set it to false in case they played a card
		EndCurrentPlayerTurn()

	else:
		if GameState.GetTurnState() != "Setup":
			#they can't skip setup
			NotifyThatTurnHasEnded()
			RefreshCards()
			GameState.ChangeTurnState()	#this acts as a 'skip' in case you don't want to play any cards of that type

		if GameState.GetTurnState() == "LocationCardPhase" and GameState.GetTurnOver() == true:
			#change to other player's turn
			NotifyThatTurnHasEnded()
			RefreshCards()
			EndCurrentPlayerTurn()

		GameState.SetTurnOver(false)	#enable cards and things again


