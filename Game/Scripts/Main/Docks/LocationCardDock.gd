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


var lastPlayerToLand = ""
#it will need to manipulate game state, can the custom script access that? Or Will I need a sunchronizing func?

signal BattleStarted()	#this is currently used
signal BattleEnded()	#this is currently never emitted


func _ready():
	playerOneDock.SetPlayerOwnershipText("Player One")
	playerTwoDock.SetPlayerOwnershipText("Player Two")
	
	playerOneDock.hide()
	playerTwoDock.hide()
	

func GetMonsterHealth(player):
	if player == "PlayerOne":
		#if the monster is set (not it's default value of 0)
		if typeof(playerOneMonster) == TYPE_OBJECT:
			return playerOneMonster.GetBattleHealth()
	else:
		if typeof(playerTwoMonster) == TYPE_OBJECT:
			return playerTwoMonster.GetBattleHealth()

func LocationCardPhysicsProcessCode():
	#you can only play a location card during setup, or during location card phase
	if GameState.GetTurnState() == "Setup":
		#then end the player's turn after they dock the location card
		#typeof(storedCard) != TYPE_OBJECT checks if there is a stored card and it's not an integer, this will allow me to prevent the stacking of multiple location cards in a single location card dock
		#add mouse in tile to fix issue where if you click and drag location card over dock it will still take it when you release click
		if cardHoveredOverArea.GetClickAndDraggedOn() == false and cardHoveredOverArea.GetCardIsDocked() == false and cardHoveredOverArea.GetCardType() == "Location" and typeof(storedCard) != TYPE_OBJECT and mouseIsInTile:
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
			
	elif GameState.GetTurnState() == "LocationCardPhase" and GameState.GetBattleState() == "":
		#make sure there's no battle somehow going on
		
		if cardHoveredOverArea.GetClickAndDraggedOn() == false and cardHoveredOverArea.GetCardIsDocked() == false and cardHoveredOverArea.GetCardType() == "Location" and typeof(storedCard) != TYPE_OBJECT and mouseIsInTile:
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
			
func LocationCardPhysicsProcessCodeTestingStub(turnState, battleState, currentTurn, passedStoredCard, passedMouseIsInTile, draggedOn, cardIsDocked, cardType):
	#you can only play a location card during setup, or during location card phase
	if turnState == "Setup":
		#then end the player's turn after they dock the location card
		#typeof(storedCard) != TYPE_OBJECT checks if there is a stored card and it's not an integer, this will allow me to prevent the stacking of multiple location cards in a single location card dock
		#add mouse in tile to fix issue where if you click and drag location card over dock it will still take it when you release click
		
		if draggedOn == false and cardIsDocked == false and cardType == "Location" and typeof(passedStoredCard) != TYPE_OBJECT and passedMouseIsInTile:
			#dock it, this is location card
			#cardHoveredOverArea.global_position = $Centre.global_position
			#connect the signals for "battle start" etc. from here to card upon docking
			#cardHoveredOverArea.ConnectCustomScriptToLocationDockSignal(thisNode)
				
			#cardHoveredOverArea.hide()
			#cardHoveredOverArea.set_process(false)
			#cardHoveredOverArea.set_physics_process(false)
			#cardHoveredOverArea.set_process_input(false)
					
			#passedCardHoveredOverArea.SetCardIsDocked(true)
			#passedStoredCard = passedCardHoveredOverArea
			#passedStoredCard.SetIsDocked(true)
			#$Sprite/Grey.texture = cardBackImage
			#set the cards position to Centre and disable/hide it
			#show it later if they mouse over or something
			#instead change the sprite to the card back image
			
			
			#if this is player two ending their turn due to it being the setup phase, 
			#then the setup phase is now over and the phase is changed to the next one
			if currentTurn == "PlayerTwo":
				turnState = "LocationCardPhase"	#from setup phase, it will change to location card phase
			
			
			#end the current player's turn, they've placed down their location card as their part of the setup phase
			if currentTurn == "PlayerTwo":
				currentTurn = "PlayerOne"
			else:
				currentTurn = "PlayerTwo"
				
			return [currentTurn, turnState,  battleState]
			
	elif turnState == "LocationCardPhase" and battleState == "":
		#make sure there's no battle somehow going on
		
		if draggedOn == false and cardIsDocked == false and cardType == "Location" and typeof(passedStoredCard) != TYPE_OBJECT and passedMouseIsInTile:
			#dock it, this is location card
			#cardHoveredOverArea.global_position = $Centre.global_position
			#connect the signals for "battle start" etc. from here to card upon docking
			#cardHoveredOverArea.ConnectCustomScriptToLocationDockSignal(thisNode)
				
			#cardHoveredOverArea.hide()
			#cardHoveredOverArea.set_process(false)
			#cardHoveredOverArea.set_physics_process(false)
			#cardHoveredOverArea.set_process_input(false)
					
			#passedCardHoveredOverArea.SetCardIsDocked(true)
			#passedStoredCard = passedCardHoveredOverArea
			#passedStoredCard.SetIsDocked(true)
			#$Sprite/Grey.texture = cardBackImage
			#set the cards position to Centre and disable/hide it
			#show it later if they mouse over or something
			#instead change the sprite to the card back image
			
			#now that they have played a location card the location card phase is over
			#switch to the next turn phase
			turnState = "MonsterCardPhase"
	
			return [currentTurn, turnState, battleState]
	
	return [0]	#this indicates that nothing happened
	
	
	
func MonsterCardPhysicsProcessCode():
	
	if GameState.GetTurnState() == "MonsterCardPhase" and GameState.GetBattleState() == "":
		#make sure there's no battle going on, and that it's the right phase
		MonsterCardPhaseHelperCode()
		
	
	
	
func MonsterCardPhaseHelperCode():
	if cardHoveredOverArea.GetClickAndDraggedOn() == false and cardHoveredOverArea.GetCardIsDocked() == false:
		if cardHoveredOverArea.GetCardType() == "Monster" and cardHoveredOverArea.GetInUsedPile() == false:
			#dock it, this is monster card
			if cardHoveredOverArea.GetCardOwner() == "PlayerOne" and thereIsPlayerOneMonster == false:
				playerOneDock.LoadMonsterCardInformation(cardHoveredOverArea)
				#still need to connect signal to display
				#get_parent().get_node("Display").ConnectMonsterDockSignal(playerOneDock)
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
				#get_parent().get_node("Display").ConnectMonsterDockSignal(playerTwoDock)
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
	
func MonsterCardPhaseHelperCodeTestingStub(draggedOn, cardIsDocked, cardType, inUsedPile, cardOwner, thereIsCardOwnerMonster, turnState, battleStarted, thereIsOtherPlayerMonster):
	if draggedOn == false and cardIsDocked == false:
		if cardType == "Monster" and inUsedPile == false:
			#dock it, this is monster card
			if cardOwner == "PlayerOne" and thereIsCardOwnerMonster == false:
				#playerOneDock.LoadMonsterCardInformation(cardHoveredOverArea)
				#still need to connect signal to display
				#get_parent().get_node("Display").ConnectMonsterDockSignal(playerOneDock)
				#print(get_parent().get_node("Display").name)
				#cardHoveredOverArea.hide()
				#cardHoveredOverArea.set_process(false)
				#cardHoveredOverArea.set_physics_process(false)
				#cardHoveredOverArea.set_process_input(false)
				#cardHoveredOverArea.SetCardIsDocked(true)
				#cardHoveredOverArea.SetCardInvolvedInBattle(true)
				
				
				#playerOneMonster = cardHoveredOverArea
				thereIsCardOwnerMonster = true
				#now that the player has placed a monster, change the turn to the next phase
				#GameState.ChangeTurnState()
				turnState = "StrategyCardPhase"
				
				
				#check if this is the second of two opposing monsters placed
				if thereIsOtherPlayerMonster:
					#SetLocationDockToRevealed()
					
					#get the index of the location card dock
					#var stringIndex = name[-1]
					#var intIndex = int(stringIndex) -1	#the list of location card docks starts at 0, so the -1 is to adjust for that
					#lastPlayerToLand = "PlayerOne"
					
					#GameState.AddCardToActiveCardList(storedCard)
					#GameState.RegisterBattleStarted(intIndex, lastPlayerToLand)
					
					#emit_signal("BattleStarted")
					battleStarted = true
				return [turnState, battleStarted, thereIsCardOwnerMonster]
					
				
			elif cardOwner == "PlayerTwo" and thereIsCardOwnerMonster == false:
				#playerTwoDock.LoadMonsterCardInformation(cardHoveredOverArea)
				#still need to connect signal to display
				#get_parent().get_node("Display").ConnectMonsterDockSignal(playerTwoDock)
				#print(get_parent().get_node("Display").name)
				#cardHoveredOverArea.hide()
				#cardHoveredOverArea.set_process(false)
				#cardHoveredOverArea.set_physics_process(false)
				#cardHoveredOverArea.set_process_input(false)
				#cardHoveredOverArea.SetCardIsDocked(true)
				#cardHoveredOverArea.SetCardInvolvedInBattle(true)
				
				
				
				#playerTwoMonster = cardHoveredOverArea
				thereIsCardOwnerMonster = true
				#now that the player has placed a monster, change the turn to the next phase
				#GameState.ChangeTurnState()
				turnState = "StrategyCardPhase"
				
				#turnstate, battlestarted, thereIsCardOwnerMonster
				#check if this is the second of two opposing monsters placed
				if thereIsOtherPlayerMonster:
					#SetLocationDockToRevealed()
					
					#get the index of the location card dock
					#var stringIndex = name[-1]
					#var intIndex = int(stringIndex) -1	#the list of location card docks starts at 0, so the -1 is to adjust for that
					#lastPlayerToLand = "PlayerTwo"
					
					#GameState.AddCardToActiveCardList(storedCard)
					
					
					#GameState.RegisterBattleStarted(intIndex, lastPlayerToLand)
					
					#emit_signal("BattleStarted")
					battleStarted = true
				return [turnState, battleStarted, thereIsCardOwnerMonster]
	return [0]
	
	

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
	
	if GameState.GetBattleState() != "" and GameState.GetBattleState() == "BattleCardPhase":
		#if there's a battle happening, and it's the right phase
	
		if cardHoveredOverArea.GetClickAndDraggedOn() == false and cardHoveredOverArea.GetCardIsDocked() == false and cardHoveredOverArea.GetCardType() == "Battle":
				#check if a battle is happening
				if thereIsPlayerOneMonster and thereIsPlayerTwoMonster and GameState.GetBattleState() == "BattleCardPhase":
					#take card, filter card, do card
					
					#they will drag the card onto the location dock where there is a battle going on
					#this card will then be filtered, then it's effect played and it added to active cards
					cardHoveredOverArea.hide()
					cardHoveredOverArea.SetCardInvolvedInBattle(true)
					var filteredBattleCardToHandle = GameState.FilterBattleCard(cardHoveredOverArea.GetFilterData())	
					
					#check if the battle card/effect is allowed
					#[attribute, true]
					if filteredBattleCardToHandle[1]:
						#call func in root to handle the effect
						
						cardIsBeingHoveredOver = false
						get_parent().HandleFilteredBattleCard(filteredBattleCardToHandle, cardHoveredOverArea)
					else:
						#card is not allowed to be played, make it visible and tell user they cannot play it
						#dock the card since it cannot be played
						
						
						
						cardHoveredOverArea.show()
						cardIsBeingHoveredOver = false
						get_parent().get_node("Dock").PlaceCard(cardHoveredOverArea)
						
func BattleCardPhysicsProcessCodeTestingStub(battleState, draggedOn, isDocked, cardType, thereIsBattle, battleCardWasAllowedByFilter):
	
	if battleState != "" and battleState == "BattleCardPhase":
		#if there's a battle happening, and it's the right phase
	
		if draggedOn == false and isDocked == false and cardType == "Battle":
				#check if a battle is happening
				if thereIsBattle and battleState == "BattleCardPhase":
					#take card, filter card, do card
					
					#they will drag the card onto the location dock where there is a battle going on
					#this card will then be filtered, then it's effect played and it added to active cards
					#cardHoveredOverArea.hide()
					#cardHoveredOverArea.SetCardInvolvedInBattle(true)
					#var filteredBattleCardToHandle = GameState.FilterBattleCard(cardHoveredOverArea.GetFilterData())	
					
					#check if the battle card/effect is allowed
					#[attribute, true]
					if battleCardWasAllowedByFilter:
						#call func in root to handle the effect
						return [battleCardWasAllowedByFilter, "allowed"]
						#cardIsBeingHoveredOver = false
						#get_parent().HandleFilteredBattleCard(filteredBattleCardToHandle, cardHoveredOverArea)
					else:
						#card is not allowed to be played, make it visible and tell user they cannot play it
						#dock the card since it cannot be played
						
						return [battleCardWasAllowedByFilter, "disallowed"]
						
						#cardHoveredOverArea.show()
						#cardIsBeingHoveredOver = false
						#get_parent().get_node("Dock").PlaceCard(cardHoveredOverArea)
	return [0]
	
func StrategyCardPhysicsProcessCode():
	
	if GameState.GetTurnState() == "StrategyCardPhase" and GameState.GetBattleState() == "":
		#make sure there's no battle going on
		StrategyCardPhaseHelperCode()
	
	
#this function checks if it's ok to dock the strategy card and call the appropriate functions to activate it's preperation
func StrategyCardPhaseHelperCode():
	#in the meantime the card itself should hide, it will reappear only if it is not allowed to be played
				#and the user should be told this
		if cardHoveredOverArea.GetClickAndDraggedOn() == false and cardHoveredOverArea.GetCardIsDocked() == false and cardHoveredOverArea.GetCardType() == "Strategy" and cardHoveredOverArea.GetCardInvolvedInBattle() == false:
			cardHoveredOverArea.hide()
			cardHoveredOverArea.SetCardIsDocked(true)	#if the card is used successfully, this will be used to signal that the card is in the used pile
			
			get_parent().SetStrategyCardBeingHandled(cardHoveredOverArea)
			get_parent().UserSelectedFromStrategyCardMenu("first time")
			
#card is a reference to a strategy card
#this function activates and handles the effect of a strategy card
func StrategyCardActivateEffectHelperCode(card):
	var effectOutcome = ""
	
	effectOutcome = card.ActivateEffect()
			
	
	if effectOutcome == "Success":
		#the card has done it's effect, move it to the used pile
		GameState.MoveAllDockedStrategyCardsToUsedPile(card.GetCardOwner())
				
		#they played the card and it was successfully played, end the phase
		#now that the player has played a strategy card, their turn is over
		#change the turn state and change the player turn
		GameState.ChangeTurnState()
		
		get_parent().EndCurrentPlayerTurn()
				
	elif effectOutcome == "Fail":
		#show card again, unset the card being docked and return it to the card dock
		#also notify the user that it could not be played
		card.show()
		card.SetCardIsDocked(false)	#if the card is used successfully, this will be used to signal that the card is in the used pile
		get_parent().PutCardBackInDock(card)
				
	else:
		print("ERROR: strategy card effect returned something other than Success or Fail")
			
	
#card is a reference to a strategy card
#this function activates and handles the effect of a strategy card
func StrategyCardActivateEffectHelperCodeTestingStub(effectOutcome):
	#var effectOutcome = ""
	
	#effectOutcome = card.ActivateEffect()
			
	
	if effectOutcome == "Success":
		#the card has done it's effect, move it to the used pile
		#GameState.MoveAllDockedStrategyCardsToUsedPile(card.GetCardOwner())
		return [effectOutcome, "pass"]
		#they played the card and it was successfully played, end the phase
		#now that the player has played a strategy card, their turn is over
		#change the turn state and change the player turn
		#GameState.ChangeTurnState()
		
		#get_parent().EndCurrentPlayerTurn()
				
	elif effectOutcome == "Fail":
		#show card again, unset the card being docked and return it to the card dock
		#also notify the user that it could not be played
		#card.show()
		#card.SetCardIsDocked(false)	#if the card is used successfully, this will be used to signal that the card is in the used pile
		#get_parent().PutCardBackInDock(card)
		return [effectOutcome, "fail"]
				
	else:
		return ["typo"]
		
	
	
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

#text, the text prompt that the strategy card menu will display to the user
func HandleStrategyCardMenuForGameState(text):
	get_parent().HandleStrategyCardMenu(text)

#player is either "PlayerOne" or "PlayerTwo"
func GetPlayerMonsterData(player):
	if player == "PlayerOne":
		return playerOneMonster.GetData()
	else:
		return playerTwoMonster.GetData()

#player is either "PlayerOne" or "PlayerTwo"
#data is the info of a monster in the form [attribute, health] 
func SetPlayerMonsterData(player, data):
	if player == "PlayerOne":
		playerOneMonster.SetData(data)
	else:
		playerTwoMonster.SetData(data)

#get the global position of the position2D at the centre of this node
func GetCenter():
	return $Centre.global_position

#check who, if anyone has won the battle
func GetVictory():
	
	var playerOneMonsterHealth = playerOneMonster.GetBattleHealth()
	var playerTwoMonsterHealth = playerTwoMonster.GetBattleHealth()
	
	if playerOneMonsterHealth <= 0:
		return "PlayerTwo"	#if player one's monster is at 0 health, then player two won
	elif playerTwoMonsterHealth <= 0:
		return "PlayerOne"
	else:
		#no one has won yet
		return "No victory"
	
	
	

#monsterAttack is in the form:
#[1, "flaming Sting", 60, "Inferno", "there is a one in eight chance this attack does 100 damage", true, true]
#where the the information is: the index of the attack(first attack), name of the attack, damage of the attack, attribute of the attack, text effect of the attack, whether the effect is enabled, whether the attack is allowed
func UseMonsterCardEffect(monsterAttack):
	if GameState.GetPlayerBattleTurn() == "PlayerOne":
		monsterAttack = playerOneMonster.ActivateMonsterCardScriptEffect(monsterAttack)
	else:
		monsterAttack = playerTwoMonster.ActivateMonsterCardScriptEffect(monsterAttack)

	return monsterAttack



#monsterAttack is in the form:
#[1, "flaming Sting", 60, "Inferno", "there is a one in eight chance this attack does 100 damage", true, true]
#where the the information is: the index of the attack(first attack), name of the attack, damage of the attack, attribute of the attack, text effect of the attack, whether the effect is enabled, whether the attack is allowed
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
	#this func is for use when changing turns between players or other battle stuff
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
		
		
		dockedCardShown = true
		
		


func _on_LocationDock_body_entered(body):
	cardHoveredOverArea = body
	cardIsBeingHoveredOver = true





func _on_LocationDock_mouse_entered():
	mouseIsInTile = true


func _on_LocationDock_mouse_exited():
	
	mouseIsInTile = false


func _on_ClickCooldown_timeout():
	timeHasPassedSinceLastClickEvent = true
