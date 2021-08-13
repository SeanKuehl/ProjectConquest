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

#next step is to manage multiple things of slots and multiple different kinds of cards
#use the cardType variable which has getters and setters to handle things

var cardHoveredOverArea = 0
var cardIsBeingHoveredOver = false

func _ready():
	pass
	





func PlaceCard(card):
	#if card's cardType is the current one, normal place it
	#otherwise hidden place it
	#occupied slots are the ones that are 1 or 0, reference 
	
	var occupiedSlots = cardTypeOccupiedSlotsDict[card.GetCardType()]
	var referenceSlots = cardTypeReferenceSlotsDict[card.GetCardType()]
	
	if card.GetCardType() == slotState:
		#regular place
		
		for x in range(numOfSlots):
			if occupiedSlots[x] == 0:
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
				occupiedSlots[x] = 1	#set the slot to occupied
				#this should update the actual occupied/reference slots, but it's a possible bug to think about
				break
	else:
		#hidden place
		for x in range(numOfSlots):
			if occupiedSlots[x] == 0:
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
	








func _on_LocationCardButton_pressed():
	slotState = "Location"
	HideAllCards()
	ShowCardSlot("Location")


func _on_MonsterCardButton_pressed():
	slotState = "Monster"
	HideAllCards()
	ShowCardSlot("Monster")


func _on_BattleCardButton_pressed():
	slotState = "Battle"
	HideAllCards()
	ShowCardSlot("Battle")


func _on_StrategyCardButton_pressed():
	slotState = "Strategy"
	HideAllCards()
	ShowCardSlot("Strategy")
