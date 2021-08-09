extends Area2D

var baseSlots = [0,0,0,0,0]	#they will be set to 1 if occupied
var baseCardSlots = [0,0,0,0,0]	#this is to store the references to the cards

var otherBaseSlots = [0,0,0,0,0]
var otherBaseCardSlots = [0,0,0,0,0]


var slotState = "Base"	#this is the kind of card it is showing

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
	
func HiddenPlaceBaseCard(card):
	
	
	for x in range(numOfSlots):
		if baseSlots[x] == 0:
			if (x+1) == 1:
				cardHoveredOverArea.position = firstSlot.global_position
			if (x+1) == 2:
				cardHoveredOverArea.position = secondSlot.global_position
			if (x+1) == 3:
				cardHoveredOverArea.position = thirdSlot.global_position
			if (x+1) == 4:
				cardHoveredOverArea.position = fourthSlot.global_position
			if (x+1) == 5:
				cardHoveredOverArea.position = fifthSlot.global_position
			#cardHoveredOverArea.position = namesOfSlots[x].global_position	#set the cards position
			cardHoveredOverArea.SetDockNumber(x+1)	#+1 because loop starts at zero, set the cards dock number
			cardHoveredOverArea.SetCardIsDocked(true)
			cardIsBeingHoveredOver = false	#there is no longer a card hovering over
			baseCardSlots[x] = card
			card.hide()
			card.set_process(false)
			card.set_physics_process(false)
			card.set_process_input(false)
			#make the card not react to anything
			#cardHoveredOverArea = 0	#clear the reference to the card
			baseSlots[x] = 1	#set the slot to occupied
			break
	
	
func PlaceBaseCard(card):
	
	for x in range(numOfSlots):
		if baseSlots[x] == 0:
			if (x+1) == 1:
				cardHoveredOverArea.position = firstSlot.global_position
			if (x+1) == 2:
				cardHoveredOverArea.position = secondSlot.global_position
			if (x+1) == 3:
				cardHoveredOverArea.position = thirdSlot.global_position
			if (x+1) == 4:
				cardHoveredOverArea.position = fourthSlot.global_position
			if (x+1) == 5:
				cardHoveredOverArea.position = fifthSlot.global_position
			#cardHoveredOverArea.position = namesOfSlots[x].global_position	#set the cards position
			cardHoveredOverArea.SetDockNumber(x+1)	#+1 because loop starts at zero, set the cards dock number
			cardHoveredOverArea.SetCardIsDocked(true)
			cardIsBeingHoveredOver = false	#there is no longer a card hovering over
			baseCardSlots[x] = cardHoveredOverArea
			#cardHoveredOverArea = 0	#clear the reference to the card
			baseSlots[x] = 1	#set the slot to occupied
			break
	



func HiddenPlaceOtherCard(card):
	
	
	for x in range(numOfSlots):
		if baseSlots[x] == 0:
			if (x+1) == 1:
				cardHoveredOverArea.position = firstSlot.global_position
			if (x+1) == 2:
				cardHoveredOverArea.position = secondSlot.global_position
			if (x+1) == 3:
				cardHoveredOverArea.position = thirdSlot.global_position
			if (x+1) == 4:
				cardHoveredOverArea.position = fourthSlot.global_position
			if (x+1) == 5:
				cardHoveredOverArea.position = fifthSlot.global_position
			#cardHoveredOverArea.position = namesOfSlots[x].global_position	#set the cards position
			cardHoveredOverArea.SetDockNumber(x+1)	#+1 because loop starts at zero, set the cards dock number
			cardHoveredOverArea.SetCardIsDocked(true)
			cardIsBeingHoveredOver = false	#there is no longer a card hovering over
			otherBaseCardSlots[x] = card
			card.hide()
			card.set_process(false)
			card.set_physics_process(false)
			card.set_process_input(false)
			#make the card not react to anything
			#cardHoveredOverArea = 0	#clear the reference to the card
			otherBaseSlots[x] = 1	#set the slot to occupied
			break
	
	
func PlaceOtherCard(card):
	
	for x in range(numOfSlots):
		if baseSlots[x] == 0:
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
			otherBaseCardSlots[x] = card
			#cardHoveredOverArea = 0	#clear the reference to the card
			otherBaseSlots[x] = 1	#set the slot to occupied
			break

func ShowBaseCards():
	#hide other cards
	for card in otherBaseCardSlots:
		if typeof(card) == TYPE_OBJECT:
			#then it's a card not a 0
			card.hide()
			card.set_process(false)
			card.set_physics_process(false)
			card.set_process_input(false)
		else:
			pass
		
	#show base cards
	for card in baseCardSlots:
		if typeof(card) == TYPE_OBJECT:
			#then it's a card not a 0
			card.show()
			card.set_process(true)
			card.set_physics_process(true)
			card.set_process_input(true)
		else:
			pass
	
	


func ShowOtherCards():
	#hide base cards
	for card in baseCardSlots:
		if typeof(card) == TYPE_OBJECT:
			#then it's a card not a 0
			card.hide()
			card.set_process(false)
			card.set_physics_process(false)
			card.set_process_input(false)
		else:
			pass
		
	#show other cards
	for card in otherBaseCardSlots:
		if typeof(card) == TYPE_OBJECT:
			#then it's a card not a 0
			card.show()
			card.set_process(true)
			card.set_physics_process(true)
			card.set_process_input(true)
		else:
			pass

func _physics_process(_delta):
	
	if cardIsBeingHoveredOver == true:
		
		#if click and dragged on = true
		
		if cardHoveredOverArea.GetClickAndDraggedOn() == false and cardHoveredOverArea.GetCardIsDocked() == false and cardHoveredOverArea.GetCardType() == "Base":
			#align card
			if slotState == "Base":
				
				#if we're showing the base cards right now
				PlaceBaseCard(cardHoveredOverArea)
			elif slotState == "Other":
				HiddenPlaceBaseCard(cardHoveredOverArea)
				
		if cardHoveredOverArea.GetClickAndDraggedOn() == false and cardHoveredOverArea.GetCardIsDocked() == false and cardHoveredOverArea.GetCardType() == "Other":
			if slotState == "Base":
				HiddenPlaceOtherCard(cardHoveredOverArea)
			elif slotState == "Other":
				PlaceOtherCard(cardHoveredOverArea)
		
		

func _on_Dock_body_entered(body):
	
	cardHoveredOverArea = body
	cardIsBeingHoveredOver = true


func _on_Dock_body_exited(body):
	if body.GetCardIsDocked() == true and body.GetCardType() == "Base":
		baseSlots[body.GetDockNumber()-1] = 0	#free the slot it was using, -1 because slots starts at 0 not 1
		baseCardSlots[body.GetDockNumber()-1] = 0	#take the reference to the card out of the slot since it should no longer be effected
		body.SetCardIsDocked(false)
	if body.GetCardIsDocked() == true and body.GetCardType() == "Other":
		otherBaseSlots[body.GetDockNumber()-1] = 0
		otherBaseCardSlots[body.GetDockNumber()-1] = 0 	#take the reference to the card out of the slot since it should no longer be effected
		body.SetCardIsDocked(false)


func _on_BaseCardButton_pressed():
	slotState = "Base"
	ShowBaseCards()
	#call the thing to switch to the base cards


func _on_OtherBaseCardButton_pressed():
	slotState = "Other"
	ShowOtherCards()
	#call the thing to switch to the other cards
