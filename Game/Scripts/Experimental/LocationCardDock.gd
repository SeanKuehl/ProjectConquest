extends Area2D

var cardIsBeingHoveredOver = false
var cardHoveredOverArea = 0

var cardBackImage = load("res://Game/Assets/Images/Experimental/CardBack.png")
var defaultImage = load("res://Game/Assets/Images/Experimental/Grey.png")

onready var thisNode = get_node("../"+name)

var storedCard = 0

var playerOneMonster = 0
var thereIsPlayerOneMonster = false

var playerTwoMonster = 0
var thereIsPlayerTwoMonster = false

var mouseIsInTile = false
var dockedCardShown = false

var timeHasPassedSinceLastClickEvent = true

onready var playerOneDock = $PlayerOneMonsterCardDock
onready var playerTwoDock = $PlayerTwoMonsterCardDock

var battleHappening = false	#so gamestate and others can find where the battle is happening
var lastPlayerToLand = ""
#it will need to manipulate game state, can the custom script access that? Or Will I need a sunchronizing func?


signal BattleStarted()	#wtf do I want this to do? be connected to the location card's script
signal BattleEnded()

func _ready():
	pass
	

	
func _physics_process(_delta):
	
	
	
	if typeof(storedCard) == TYPE_OBJECT and GameState.GetBattleState() != "MonsterAttackPhase":
		#then it hasn't been assigned yet and is still an int
	
		if Input.is_action_pressed("CLICK") and mouseIsInTile and dockedCardShown == false and timeHasPassedSinceLastClickEvent and GameState.GetCurrentTurn() == storedCard.GetCardOwner():
			
			#show the docked card, show  the card and change the background sprite to grey and send signal to show card
			$Sprite/Grey.texture = defaultImage
			storedCard.show()
			#storedCard.set_process(true)
			#storedCard.set_physics_process(true)
			#storedCard.set_process_input(true)
			var valuesToDisplay = storedCard.GetDisplayStuff()
			dockedCardShown = true
			timeHasPassedSinceLastClickEvent = false
			$ClickCooldown.start()
			
			
			storedCard.emit_signal("userWantsToDisplayCard", valuesToDisplay[0], valuesToDisplay[1], valuesToDisplay[2])
			#userWantsToDisplayCard(cardName, cardPicture, cardDescription)
		if Input.is_action_just_pressed("CLICK") and mouseIsInTile and dockedCardShown == true and timeHasPassedSinceLastClickEvent and GameState.GetCurrentTurn() == storedCard.GetCardOwner():
			
			#hide the docked card, hide and disable the card and change the background sprite to the card back
			$Sprite/Grey.texture = cardBackImage
			storedCard.hide()
			storedCard.set_process(false)
			storedCard.set_physics_process(false)
			storedCard.set_process_input(false)
			dockedCardShown = false
			timeHasPassedSinceLastClickEvent = false
			$ClickCooldown.start()
		
	if cardIsBeingHoveredOver == true:
			
		#if click and dragged on = true
			
		if cardHoveredOverArea.GetClickAndDraggedOn() == false and cardHoveredOverArea.GetCardIsDocked() == false and cardHoveredOverArea.GetCardType() == "Location":
			#dock it, this is location card
			cardHoveredOverArea.global_position = $Centre.global_position
			#connect the signals for "battle start" etc. from here to card upon docking
			cardHoveredOverArea.ConnectCustomScriptToLocationDockSignal(thisNode)
			
			cardHoveredOverArea.hide()
			cardHoveredOverArea.set_process(false)
			cardHoveredOverArea.set_physics_process(false)
			cardHoveredOverArea.set_process_input(false)
				
			cardHoveredOverArea.SetCardIsDocked(true)
			storedCard = cardHoveredOverArea
			storedCard.SetIsDocked(true)
			$Sprite/Grey.texture = cardBackImage
			#set the cards position to Centre and disable/hide it
			#show it later if they mouse over or something
			#instead change the sprite to the card back image
				
				
				
		if cardHoveredOverArea.GetClickAndDraggedOn() == false and cardHoveredOverArea.GetCardIsDocked() == false and cardHoveredOverArea.GetCardType() == "Monster":
			#dock it, this is monster card
			if cardHoveredOverArea.GetCardOwner() == "PlayerOne" and thereIsPlayerOneMonster == false:
				playerOneDock.LoadMonsterCardInformation(cardHoveredOverArea)
				#still need to connect signal to display
				get_parent().get_node("Display").ConnectMonsterDockSignal(playerOneDock)
				#print(get_parent().get_node("Display").name)
				cardHoveredOverArea.hide()
				cardHoveredOverArea.set_process(false)
				cardHoveredOverArea.set_physics_process(false)
				cardHoveredOverArea.set_process_input(false)
				cardHoveredOverArea.SetCardIsDocked(true)
				playerOneMonster = cardHoveredOverArea
				thereIsPlayerOneMonster = true
				
				#check if this is the second of two opposing monsters placed
				if thereIsPlayerTwoMonster:
					SetLocationDockToRevealed()
					
					#get the index of the location card dock
					var stringIndex = name[-1]
					var intIndex = int(stringIndex) -1	#the list of location card docks starts at 0, so the -1 is to adjust for that
					lastPlayerToLand = "PlayerOne"
					
					GameState.RegisterBattleStarted(intIndex, lastPlayerToLand)
					
					emit_signal("BattleStarted")
					
					
				
			elif cardHoveredOverArea.GetCardOwner() == "PlayerTwo" and thereIsPlayerTwoMonster == false:
				playerTwoDock.LoadMonsterCardInformation(cardHoveredOverArea)
				#still need to connect signal to display
				get_parent().get_node("Display").ConnectMonsterDockSignal(playerTwoDock)
				#print(get_parent().get_node("Display").name)
				cardHoveredOverArea.hide()
				cardHoveredOverArea.set_process(false)
				cardHoveredOverArea.set_physics_process(false)
				cardHoveredOverArea.set_process_input(false)
				cardHoveredOverArea.SetCardIsDocked(true)
				playerTwoMonster = cardHoveredOverArea
				thereIsPlayerTwoMonster = true
				
				#check if this is the second of two opposing monsters placed
				if thereIsPlayerOneMonster:
					SetLocationDockToRevealed()
					
					#get the index of the location card dock
					var stringIndex = name[-1]
					var intIndex = int(stringIndex) -1	#the list of location card docks starts at 0, so the -1 is to adjust for that
					lastPlayerToLand = "PlayerTwo"
					
					GameState.RegisterBattleStarted(intIndex, lastPlayerToLand)
					
					emit_signal("BattleStarted")
					
					
					
			
			#cardHoveredOverArea.global_position = $Centre.global_position
			
				
			#cardHoveredOverArea.SetCardIsDocked(true)
			#storedCard = cardHoveredOverArea
			#storedCard.SetIsDocked(true)
			#$Sprite/Grey.texture = cardBackImage
			#set the cards position to Centre and disable/hide it
			#show it later if they mouse over or something
			#instead change the sprite to the card back image
				
		


func RootShowMonsterAttackOptions():
	#I have the cards stored here, so I'll get their information here
	#I need the attacks from the monster
	var monsterAttackInformation = 0
	if GameState.GetPlayerBattleTurn() == "PlayerOne":
		#this func could only be reached from MonsterAttackPhase so I should use battleTurn instead of regular turn
		monsterAttackInformation = playerOneMonster.GetAttacksToDisplay()
	else:
		monsterAttackInformation = playerTwoMonster.GetAttacksToDisplay()
	
	
	get_parent().ShowMonsterAttackOptions(monsterAttackInformation)


func GetCenter():
	return $Centre.global_position


func SetLocationDockToHidden():
	#this func is for use when changing turns between players
	#hide the docked card, hide and disable the card and change the background sprite to the card back
	if typeof(storedCard) == TYPE_OBJECT:
		#if the stored card is not an int(no stored card)
		$Sprite/Grey.texture = cardBackImage
		storedCard.hide()
		storedCard.set_process(false)
		storedCard.set_physics_process(false)
		storedCard.set_process_input(false)
		dockedCardShown = false
		timeHasPassedSinceLastClickEvent = true
		#$ClickCooldown.start()
	
func SetLocationDockToRevealed():
	#this is used for battles, the card must reveal to both players for a battle
	if typeof(storedCard) == TYPE_OBJECT:
		$Sprite/Grey.texture = defaultImage
		storedCard.show()
		#storedCard.set_process(true)
		#storedCard.set_physics_process(true)
		#storedCard.set_process_input(true)
		
		dockedCardShown = true
		
		


func _on_LocationDock_body_entered(body):
	cardHoveredOverArea = body
	cardIsBeingHoveredOver = true


func _on_LocationDock_body_exited(body):

	pass


func _on_LocationDock_mouse_entered():
	mouseIsInTile = true


func _on_LocationDock_mouse_exited():
	
	mouseIsInTile = false


func _on_ClickCooldown_timeout():
	timeHasPassedSinceLastClickEvent = true
