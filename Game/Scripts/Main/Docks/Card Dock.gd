extends Area2D




var monsterCardOccupiedSlots = [0,0,0,0,0]
var monsterCardReferenceSlots = [0,0,0,0,0]	#contains references to the actual cards

var locationCardOccupiedSlots = [0,0,0,0,0]
var locationCardReferenceSlots = [0,0,0,0,0]

var battleCardOccupiedSlots = [0,0,0,0,0]
var battleCardReferenceSlots = [0,0,0,0,0]

var strategyCardOccupiedSlots = [0,0,0,0,0]
var strategyCardReferenceSlots = [0,0,0,0,0]

var cardTypeOccupiedSlotsDict = {"Monster": monsterCardOccupiedSlots,
"Location": locationCardOccupiedSlots, "Battle": battleCardOccupiedSlots,
"Strategy": strategyCardOccupiedSlots}

var cardTypeReferenceSlotsDict = {"Monster": monsterCardReferenceSlots,
"Location": locationCardReferenceSlots, "Battle": battleCardReferenceSlots,
"Strategy": strategyCardReferenceSlots}

var listOfAllReferenceSlotLists = [monsterCardReferenceSlots, locationCardReferenceSlots, battleCardReferenceSlots, strategyCardReferenceSlots]
var listOfAllOccupiedSlotLists = [monsterCardOccupiedSlots, locationCardOccupiedSlots, battleCardOccupiedSlots, strategyCardOccupiedSlots]



var slotState = "Location"	#this is the kind of card it is showing

var numOfSlots = 5
onready var firstSlot = $FirstSpot
onready var secondSlot = $SecondSpot
onready var thirdSlot = $ThirdSpot
onready var fourthSlot = $FourthSpot
onready var fifthSlot = $FifthSpot

onready var locationCardButton = $LocationCardButton
onready var monsterCardButton = $MonsterCardButton
onready var battleCardButton = $BattleCardButton
onready var strategyCardButton = $StrategyCardButton


var styleThing = 0
var defaultStyle = 0


var cardHoveredOverArea = 0
var cardIsBeingHoveredOver = false

func _ready():
	styleThing = StyleBoxFlat.new()
	styleThing.bg_color = Color(0.062745, 0.415686, 0.25098)
	
	defaultStyle = StyleBoxEmpty.new()
	
	#the slotState is location cards by default, so make the location card 
	#button highlighted with the style to show that that's the dock it's on
	locationCardButton.set("custom_styles/normal", styleThing)


func SetButtonHighlightToDefault():
	GiveLastButtonPressedStyle(locationCardButton)

func ClearAll():
	#this is used when switching from one player's turn to another
	#the global gamestate has references for the cards, so no need to worry
	#about losing them
	
	
			
	
	monsterCardOccupiedSlots = [0,0,0,0,0]
	monsterCardReferenceSlots = [0,0,0,0,0]	#contains references to the actual cards

	locationCardOccupiedSlots = [0,0,0,0,0]
	locationCardReferenceSlots = [0,0,0,0,0]

	battleCardOccupiedSlots = [0,0,0,0,0]
	battleCardReferenceSlots = [0,0,0,0,0]

	strategyCardOccupiedSlots = [0,0,0,0,0]
	strategyCardReferenceSlots = [0,0,0,0,0]
	#it says that it places the same card twice, this is worth looking into
	
	#clear the references in the dicts and lists by setting them here
	cardTypeOccupiedSlotsDict = {"Monster": monsterCardOccupiedSlots,
	"Location": locationCardOccupiedSlots, "Battle": battleCardOccupiedSlots,
	"Strategy": strategyCardOccupiedSlots}

	cardTypeReferenceSlotsDict = {"Monster": monsterCardReferenceSlots,
	"Location": locationCardReferenceSlots, "Battle": battleCardReferenceSlots,
	"Strategy": strategyCardReferenceSlots}

	listOfAllReferenceSlotLists = [monsterCardReferenceSlots, locationCardReferenceSlots, battleCardReferenceSlots, strategyCardReferenceSlots]
	listOfAllOccupiedSlotLists = [monsterCardOccupiedSlots, locationCardOccupiedSlots, battleCardOccupiedSlots, strategyCardOccupiedSlots]

	
	#reset slotState to the default
	slotState = "Location"
	cardHoveredOverArea = 0

	

func PlaceCard(card):
	
	#if card's cardType is the current slot state, normal place it
	#otherwise hidden place it
	#occupied slots are the ones that are 1 or 0, reference 
	
	var occupiedSlots = 0
	var referenceSlots = 0
	
	
	
	if card.GetCardType() == "Location":
		occupiedSlots = locationCardOccupiedSlots
		referenceSlots = locationCardReferenceSlots
	if card.GetCardType() == "Monster":
		occupiedSlots = monsterCardOccupiedSlots
		referenceSlots = monsterCardReferenceSlots
	if card.GetCardType() == "Battle":
		occupiedSlots = battleCardOccupiedSlots
		referenceSlots = battleCardReferenceSlots
	if card.GetCardType() == "Strategy":
		occupiedSlots = strategyCardOccupiedSlots
		referenceSlots = strategyCardReferenceSlots
	
	
	#there is something wrong with the use of the dictionaries above
	if card.GetCardType() == slotState:
		#regular place
		
		
		for x in range(numOfSlots):
			if occupiedSlots[x] == 0 and card.GetCardIsDocked() == false:
				
				#the slot is free
				if (x+1) == 1:
					card.position = firstSlot.global_position
				if (x+1) == 2:
					card.position = secondSlot.global_position
				if (x+1) == 3:
					card.position = thirdSlot.global_position
				if (x+1) == 4:
					card.position = fourthSlot.global_position
				if (x+1) == 5:
					card.position = fifthSlot.global_position
				card.SetDockNumber(x+1)	#+1 because loop starts at zero, set the cards dock number
				card.SetCardIsDocked(true)
				cardIsBeingHoveredOver = false	#there is no longer a card hovering over
				referenceSlots[x] = card
				#cardHoveredOverArea = 0	#clear the reference to the card
				#just in case the card was set to hidden previousely
				card.show()
				card.set_process(true)
				card.set_physics_process(true)
				card.set_process_input(true)
				occupiedSlots[x] = 1	#set the slot to occupied
				#this should update the actual occupied/reference slots, but it's a possible bug to think about
				
				break
	else:
		#hidden place
		
		
		for x in range(numOfSlots):
			if occupiedSlots[x] == 0 and card.GetCardIsDocked() == false:
				if (x+1) == 1:
					card.position = firstSlot.global_position
				if (x+1) == 2:
					card.position = secondSlot.global_position
				if (x+1) == 3:
					card.position = thirdSlot.global_position
				if (x+1) == 4:
					card.position = fourthSlot.global_position
				if (x+1) == 5:
					card.position = fifthSlot.global_position
				#cardHoveredOverArea.position = namesOfSlots[x].global_position	#set the cards position
				card.SetDockNumber(x+1)	#+1 because loop starts at zero, set the cards dock number
				card.SetCardIsDocked(true)
				cardIsBeingHoveredOver = false	#there is no longer a card hovering over
				referenceSlots[x] = card
				card.hide()
				card.set_process(false)
				card.set_physics_process(false)
				card.set_process_input(false)
				#make the card not react to anything
				#cardHoveredOverArea = 0	#clear the reference to the card
				occupiedSlots[x] = 1	#set the slot to occupied
				break
	

func HideAllCards():
	for cardList in listOfAllReferenceSlotLists:
		for card in cardList:
			if typeof(card) == TYPE_OBJECT:
				#then it's a card not a 0
				card.hide()
				card.set_process(false)
				card.set_physics_process(false)
				card.set_process_input(false)

func ShowCardSlot(cardSlotToShow):
	var cardSlot = cardTypeReferenceSlotsDict[cardSlotToShow]
	
	for card in cardSlot:
		if typeof(card) == TYPE_OBJECT:
			#then it's a card not a 0
			card.show()
			card.set_process(true)
			card.set_physics_process(true)
			card.set_process_input(true)


func _physics_process(_delta):
	
	if cardIsBeingHoveredOver == true:
		
		#if click and dragged on = true
		
		if cardHoveredOverArea.GetClickAndDraggedOn() == false and cardHoveredOverArea.GetCardIsDocked() == false:
			#align card
			
			PlaceCard(cardHoveredOverArea)
				
		
func LoadPlayerCards(listOfCards):
	
	var locationCards = listOfCards[0]
	var monsterCards = listOfCards[1]
	var battleCards = listOfCards[2]
	var strategyCards = listOfCards[3]
	
	for x in locationCards:
		
		if x.GetIsDocked():
			
			#gotta replace the above with something meant for this singular purpose
			
			#it's a part of a battle
			pass
		else:
			
			x.SetCardIsDocked(false)	#otherwise this will enter the Place function but will not be placed and just not do anything
			PlaceCard(x)
		
	#GetCardIsDocked(), but for location it's GetIsDocked()
	for x in monsterCards:
		
		if x.GetCardInvolvedInBattle():
			
			
			#it's a part of a battle
			pass
		else:
			
			x.SetCardIsDocked(false)	#otherwise this will enter the Place function but will not be placed and just not do anything
			PlaceCard(x)
		
	for x in battleCards:
		
		if x.GetCardInvolvedInBattle():
			
			#it's a part of a battle
			pass
		else:
			
			x.SetCardIsDocked(false)	#otherwise this will enter the Place function but will not be placed and just not do anything
			PlaceCard(x)
		
	for x in strategyCards:
		
		if x.GetCardInvolvedInBattle():
			
			#it will never really be involved in battle, but this will
			#be set true when it is used
			
			pass
		else:
			
			x.SetCardIsDocked(false)	#otherwise this will enter the Place function but will not be placed and just not do anything
			PlaceCard(x)
		

func _on_Dock_body_entered(body):
	
	cardHoveredOverArea = body
	
	cardIsBeingHoveredOver = true


func _on_Dock_body_exited(body):
	var occupiedSlots = cardTypeOccupiedSlotsDict[body.GetCardType()]
	var referenceSlots = cardTypeReferenceSlotsDict[body.GetCardType()]
	
	if body.GetCardIsDocked() == true:
		occupiedSlots[body.GetDockNumber()-1] = 0	#free the slot it was using, -1 because slots starts at 0 not 1
		referenceSlots[body.GetDockNumber()-1] = 0	#take the reference to the card out of the slot since it should no longer be effected
		body.SetCardIsDocked(false)
		cardIsBeingHoveredOver = false
	



func GiveLastButtonPressedStyle(lastButtonPressed):
	#set all buttons to blank
	locationCardButton.set("custom_styles/normal", defaultStyle)
	monsterCardButton.set("custom_styles/normal", defaultStyle)
	battleCardButton.set("custom_styles/normal", defaultStyle)
	strategyCardButton.set("custom_styles/normal", defaultStyle)
	
	#set the last button pressed to the highlight style
	lastButtonPressed.set("custom_styles/normal", styleThing)


func _on_LocationCardButton_pressed():
	
	GiveLastButtonPressedStyle(locationCardButton)
	slotState = "Location"
	HideAllCards()
	ShowCardSlot("Location")


func _on_MonsterCardButton_pressed():
	GiveLastButtonPressedStyle(monsterCardButton)
	slotState = "Monster"
	HideAllCards()
	ShowCardSlot("Monster")


func _on_BattleCardButton_pressed():
	GiveLastButtonPressedStyle(battleCardButton)
	slotState = "Battle"
	HideAllCards()
	ShowCardSlot("Battle")


func _on_StrategyCardButton_pressed():
	GiveLastButtonPressedStyle(strategyCardButton)
	slotState = "Strategy"
	HideAllCards()
	ShowCardSlot("Strategy")
