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
	

func LocationCardPhysicsProcessCode():
	#eventually this will have a check for if there's a battle going on or not,
	#if it's a battle(normally) follow the battle state stuff
	if GameState.GetTurnState() == "Setup":
		#then end the player's turn after they dock the location card
		#typeof(storedCard) != TYPE_OBJECT checks if there is a stored card and it's not an integer, this will allow me to prevent the stacking of multiple location cards in a single location card dock
		if cardHoveredOverArea.GetClickAndDraggedOn() == false and cardHoveredOverArea.GetCardIsDocked() == false and cardHoveredOverArea.GetCardType() == "Location" and typeof(storedCard) != TYPE_OBJECT:
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
			
			
			#if this is player two ending their turn due to it being the setup phase, 
			#then the setup phase is now over and the phase is changed to the next one
			if GameState.GetCurrentTurn() == "PlayerTwo":
				GameState.ChangeTurnState()	#from setup phase, it will change to location card phase
			
			
			#end the current player's turn, they've placed down their location card as their part of the setup phase
			get_parent().EndCurrentPlayerTurn()
			
	elif GameState.GetTurnState() == "LocationCardPhase":
		
		if cardHoveredOverArea.GetClickAndDraggedOn() == false and cardHoveredOverArea.GetCardIsDocked() == false and cardHoveredOverArea.GetCardType() == "Location" and typeof(storedCard) != TYPE_OBJECT:
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
			
			#now that they have played a location card the location card phase is over
			#switch to the next turn phase
			GameState.ChangeTurnState()
			print(GameState.GetTurnState())
			
	else:
		if cardHoveredOverArea.GetClickAndDraggedOn() == false and cardHoveredOverArea.GetCardIsDocked() == false and cardHoveredOverArea.GetCardType() == "Location" and typeof(storedCard) != TYPE_OBJECT:
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
	
func MonsterCardPhysicsProcessCode():
	
	if GameState.GetTurnState() == "MonsterCardPhase":
		MonsterCardPhaseHelperCode()
		
	else:
		MonsterCardPhysicsProcessHelperCode()
	
	
func MonsterCardPhaseHelperCode():
	if cardHoveredOverArea.GetClickAndDraggedOn() == false and cardHoveredOverArea.GetCardIsDocked() == false:
		if cardHoveredOverArea.GetCardType() == "Monster" and cardHoveredOverArea.GetInUsedPile() == false:
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
				cardHoveredOverArea.SetCardInvolvedInBattle(true)
				
				
				playerOneMonster = cardHoveredOverArea
				thereIsPlayerOneMonster = true
				#now that the player has placed a monster, change the turn to the next phase
				GameState.ChangeTurnState()
				print(GameState.GetTurnState())
				
				#check if this is the second of two opposing monsters placed
				if thereIsPlayerTwoMonster:
					SetLocationDockToRevealed()
					
					#get the index of the location card dock
					var stringIndex = name[-1]
					var intIndex = int(stringIndex) -1	#the list of location card docks starts at 0, so the -1 is to adjust for that
					lastPlayerToLand = "PlayerOne"
					
					GameState.AddCardToActiveCardList(storedCard)
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
				cardHoveredOverArea.SetCardInvolvedInBattle(true)
				
				
				
				playerTwoMonster = cardHoveredOverArea
				thereIsPlayerTwoMonster = true
				#now that the player has placed a monster, change the turn to the next phase
				GameState.ChangeTurnState()
				print(GameState.GetTurnState())
				
				#check if this is the second of two opposing monsters placed
				if thereIsPlayerOneMonster:
					SetLocationDockToRevealed()
					
					#get the index of the location card dock
					var stringIndex = name[-1]
					var intIndex = int(stringIndex) -1	#the list of location card docks starts at 0, so the -1 is to adjust for that
					lastPlayerToLand = "PlayerTwo"
					
					GameState.AddCardToActiveCardList(storedCard)
					
					
					GameState.RegisterBattleStarted(intIndex, lastPlayerToLand)
					
					emit_signal("BattleStarted")
	
	
func MonsterCardPhysicsProcessHelperCode():
	if cardHoveredOverArea.GetClickAndDraggedOn() == false and cardHoveredOverArea.GetCardIsDocked() == false:
		if cardHoveredOverArea.GetCardType() == "Monster" and cardHoveredOverArea.GetInUsedPile() == false:
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
				cardHoveredOverArea.SetCardInvolvedInBattle(true)
				
				
				playerOneMonster = cardHoveredOverArea
				thereIsPlayerOneMonster = true
				
				#check if this is the second of two opposing monsters placed
				if thereIsPlayerTwoMonster:
					SetLocationDockToRevealed()
					
					#get the index of the location card dock
					var stringIndex = name[-1]
					var intIndex = int(stringIndex) -1	#the list of location card docks starts at 0, so the -1 is to adjust for that
					lastPlayerToLand = "PlayerOne"
					
					GameState.AddCardToActiveCardList(storedCard)
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
				cardHoveredOverArea.SetCardInvolvedInBattle(true)
				
				
				
				playerTwoMonster = cardHoveredOverArea
				thereIsPlayerTwoMonster = true
				
				#check if this is the second of two opposing monsters placed
				if thereIsPlayerOneMonster:
					SetLocationDockToRevealed()
					
					#get the index of the location card dock
					var stringIndex = name[-1]
					var intIndex = int(stringIndex) -1	#the list of location card docks starts at 0, so the -1 is to adjust for that
					lastPlayerToLand = "PlayerTwo"
					
					GameState.AddCardToActiveCardList(storedCard)
					
					
					GameState.RegisterBattleStarted(intIndex, lastPlayerToLand)
					
					emit_signal("BattleStarted")
	
func ShowingOrHidingStoredCardPhysicsProcessCode():
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
	
func BattleCardPhysicsProcessCode():
	if cardHoveredOverArea.GetClickAndDraggedOn() == false and cardHoveredOverArea.GetCardIsDocked() == false and cardHoveredOverArea.GetCardType() == "Battle":
			#check if a battle is happening
			if thereIsPlayerOneMonster and thereIsPlayerTwoMonster and GameState.GetBattleState() == "BattleCardPhase":
				#take card, filter card, do card
				print("this worked and got here")
				#they will drag the card onto the location dock where there is a battle going on
				#this card will then be filtered, then it's effect played and it added to active cards
				cardHoveredOverArea.hide()
				cardHoveredOverArea.SetCardInvolvedInBattle(true)
				var filteredBattleCardToHandle = GameState.FilterBattleCard(cardHoveredOverArea.GetFilterData())	
				
				#check if the battle card/effect is allowed
				#[attribute, true]
				if filteredBattleCardToHandle[1]:
					#call func in root to handle the effect
					print("this is in this location")
					cardIsBeingHoveredOver = false
					get_parent().HandleFilteredBattleCard(filteredBattleCardToHandle, cardHoveredOverArea)
				else:
					#card is not allowed to be played, make it visible and tell user they cannot play it
					#dock the card since it cannot be played
					
					
					
					cardHoveredOverArea.show()
					cardIsBeingHoveredOver = false
					get_parent().get_node("Dock").PlaceCard(cardHoveredOverArea)
					print("this card cannot be played")
	
func StrategyCardPhysicsProcessCode():
	
	if GameState.GetTurnState() == "StrategyCardPhase":
		StrategyCardPhaseHelperCode()
	else:
		StrategyCardPhysicsProcessHelperCode()
	

func StrategyCardPhaseHelperCode():
	#in the meantime the card itself should hide, it will reappear only if it is not allowed to be played
				#and the user should be told this
		if cardHoveredOverArea.GetClickAndDraggedOn() == false and cardHoveredOverArea.GetCardIsDocked() == false and cardHoveredOverArea.GetCardType() == "Strategy" and cardHoveredOverArea.GetCardInvolvedInBattle() == false:
			cardHoveredOverArea.hide()
			cardHoveredOverArea.SetCardIsDocked(true)	#if the card is used successfully, this will be used to signal that the card is in the used pile
			var effectOutcome = cardHoveredOverArea.ActivateEffect()
			print(effectOutcome)
			effectOutcome  = "Success"	#this is temp until I get around to deleting the yields etc.
			if effectOutcome == "Success":
				#the card has done it's effect, move it to the used pile
				GameState.MoveAllDockedStrategyCardsToUsedPile(cardHoveredOverArea.GetCardOwner())
				
				#they played the card and it was successfully played, end the phase
				#now that the player has played a strategy card, their turn is over
				#change the turn state and change the player turn
				GameState.ChangeTurnState()
				print(GameState.GetTurnState())
				get_parent().EndCurrentPlayerTurn()
				
			elif effectOutcome == "Fail":
				#show card again, unset the card being docked and return it to the card dock
				#also notify the user that it could not be played
				cardHoveredOverArea.show()
				cardHoveredOverArea.SetCardIsDocked(false)	#if the card is used successfully, this will be used to signal that the card is in the used pile
				get_parent().PutCardBackInDock(cardHoveredOverArea)
				
			else:
				print("ERROR: strategy card effect returned something other than Success or Fail")
			
	
func StrategyCardPhysicsProcessHelperCode():
	#in the meantime the card itself should hide, it will reappear only if it is not allowed to be played
				#and the user should be told this
		if cardHoveredOverArea.GetClickAndDraggedOn() == false and cardHoveredOverArea.GetCardIsDocked() == false and cardHoveredOverArea.GetCardType() == "Strategy" and cardHoveredOverArea.GetCardInvolvedInBattle() == false:
			cardHoveredOverArea.hide()
			cardHoveredOverArea.SetCardIsDocked(true)	#if the card is used successfully, this will be used to signal that the card is in the used pile
			var effectOutcome = cardHoveredOverArea.ActivateEffect()
			print(effectOutcome)
			
			effectOutcome  = "Success"	#this is temp until I get around to deleting the yields etc.
			if effectOutcome == "Success":
				#the card has done it's effect, move it to the used pile
				GameState.MoveAllDockedStrategyCardsToUsedPile(cardHoveredOverArea.GetCardOwner())
				
			elif effectOutcome == "Fail":
				#show card again, unset the card being docked and return it to the card dock
				#also notify the user that it could not be played
				cardHoveredOverArea.show()
				cardHoveredOverArea.SetCardIsDocked(false)	#if the card is used successfully, this will be used to signal that the card is in the used pile
				get_parent().PutCardBackInDock(cardHoveredOverArea)
				
			else:
				print("ERROR: strategy card effect returned something other than Success or Fail")
			
	
	
func _physics_process(_delta):
	
	
	
	ShowingOrHidingStoredCardPhysicsProcessCode()
		
	if cardIsBeingHoveredOver == true:
			
		
			
		LocationCardPhysicsProcessCode()
				
				
				
		MonsterCardPhysicsProcessCode()
					
					
					
		BattleCardPhysicsProcessCode()
				
		StrategyCardPhysicsProcessCode()
		


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


func HandleStrategyCardMenuForGameState(text):
	return get_parent().HandleStrategyCardMenu(text)

func GetPlayerMonsterData(player):
	if player == "PlayerOne":
		return playerOneMonster.GetData()
	else:
		return playerTwoMonster.GetData()

func SetPlayerMonsterData(player, data):
	if player == "PlayerOne":
		playerOneMonster.SetData(data)
	else:
		playerTwoMonster.SetData(data)


func GetCenter():
	return $Centre.global_position

func GetVictory():
	#returns string
	var playerOneMonsterHealth = playerOneMonster.GetBattleHealth()
	var playerTwoMonsterHealth = playerTwoMonster.GetBattleHealth()
	
	if playerOneMonsterHealth <= 0:
		return "PlayerTwo"	#if player one's monster is at 0 health, then player two won
	elif playerTwoMonsterHealth <= 0:
		return "PlayerOne"
	else:
		#no one has won yet
		return "No victory"
	
	
	


func UseMonsterCardEffect(monsterAttack):
	if GameState.GetPlayerBattleTurn() == "PlayerOne":
		monsterAttack = playerOneMonster.ActivateMonsterCardScriptEffect(monsterAttack)
	else:
		monsterAttack = playerTwoMonster.ActivateMonsterCardScriptEffect(monsterAttack)

	return monsterAttack

func DealDamageToMonster(monsterAttack):
	if GameState.GetPlayerBattleTurn() == "PlayerOne":
		#if the attack is happening on player one's turn, deal the damage
		#to player two's monster
		playerTwoMonster.TakeDamage(monsterAttack)
		
	else:
		#if the attack is happening on player two's turn, deal the damage
		#to player one's monster
		playerOneMonster.TakeDamage(monsterAttack)
		

func ClearBattleData():
	
	#clear out the monster card docks
	playerOneDock.ClearMonsterCardData()
	playerTwoDock.ClearMonsterCardData()
	
	#store references to monster and location cards so they can be processed
	#by the root
	
	
	
	#clear references to monsters and location card
	#set monsters and location card's docked statuses to not docked
	storedCard.SetIsDocked(false)
	storedCard = 0	#this is the reference to the location card

	playerOneMonster.SetInUsedPile(true)
	playerOneMonster = 0
	thereIsPlayerOneMonster = false


	playerTwoMonster.SetInUsedPile(true)
	playerTwoMonster = 0
	thereIsPlayerTwoMonster = false
	
	
	#set image to grey, set other values to blank
	lastPlayerToLand = ""
	dockedCardShown = false
	$Sprite/Grey.texture = defaultImage
	
	
	
	
	
	
	


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
