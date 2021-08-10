extends Area2D

var cardIsBeingHoveredOver = false
var cardHoveredOverArea = 0

var cardBackImage = load("res://Game/Assets/Images/Experimental/CardBack.png")
var defaultImage = load("res://Game/Assets/Images/Experimental/Grey.png")

var storedCard = 0

var mouseIsInTile = false
var dockedCardShown = false

var timeHasPassedSinceLastClickEvent = true


func _ready():
	pass
	

	
func _physics_process(_delta):
	
	if typeof(storedCard) == TYPE_OBJECT:
		#then it hasn't been assigned yet and is still an int
	
		if Input.is_action_pressed("CLICK") and mouseIsInTile and dockedCardShown == false and timeHasPassedSinceLastClickEvent:
			
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
		if Input.is_action_just_pressed("CLICK") and mouseIsInTile and dockedCardShown == true and timeHasPassedSinceLastClickEvent:
			
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
			#dock it
			cardHoveredOverArea.global_position = $Centre.global_position
			cardHoveredOverArea.hide()
			cardHoveredOverArea.set_process(false)
			cardHoveredOverArea.set_physics_process(false)
			cardHoveredOverArea.set_process_input(false)
				
			cardHoveredOverArea.SetCardIsDocked(true)
			storedCard = cardHoveredOverArea
			$Sprite/Grey.texture = cardBackImage
			#set the cards position to Centre and disable/hide it
			#show it later if they mouse over or something
			#instead change the sprite to the card back image
				
		
		
		


	



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
