extends Area2D

var slots = [0,0,0,0,0]	#they will be set to 1 if occupied

var cardSize = 100
var spaceBetweenCards = 25
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
	
	
	for x in range(numOfSlots):
		if slots[x] == 0:
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
			cardHoveredOverArea = 0	#clear the reference to the card
			slots[x] = 1	#set the slot to occupied
			break
	
	
	
	
	
#change to a slot system with multiple position2d's and store a list of all the cards docked
#use their dockNumber to keep track of them

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
	if body.GetCardIsDocked() == true:
		slots[body.GetDockNumber()-1] = 0	#free the slot it was using, -1 because slots starts at 0 not 1
		body.SetCardIsDocked(false)
