extends CanvasLayer

var timerStarted = false
var endTurnNotification = false

func _ready():
	HideMyStuff()
	
func HideMyStuff():
	$Color.hide()
	$ActivationText.hide()
	#timer isn't visual so don't need to hide it
	
func ShowMyStuff():
	$Color.show()
	$ActivationText.show()
	#timer isn't visual so don't need to show it
	
func _physics_process(_delta):
	if $ExistenceTimer.is_stopped() and timerStarted:
		HideMyStuff()
		timerStarted = false
		if endTurnNotification:
			$ExistenceTimer.wait_time = 3	#set back to usual
			endTurnNotification = false
		
	
	
func SetEndTurnNotification():
	var blackImage = load("res://Game/Assets/Images/Experimental/Black.png")
	$Color.texture = blackImage
	$ExistenceTimer.wait_time = 1	#normally 3, set it back to 3 once done
	var textToDisplay = ""
	endTurnNotification = true
	textToDisplay = "Phase Over"
	
	
	$ActivationText.text = textToDisplay
	ShowMyStuff()
	$ExistenceTimer.start()
	timerStarted = true
	
func DisplayCard(cardColor, cardType, cardName):
	$Color.texture = cardColor
	var textToDisplay = ""
	
	if cardType == "Monster":
		textToDisplay = cardName + " storms into battle!"
		
	if cardType == "Location":
		
		textToDisplay = cardName+" changes things up!"
		
	if cardType == "Battle":
		textToDisplay = "Battle card activate: "+cardName
		
	if cardType == "Strategy":
		textToDisplay = "Strategy card activate: "+cardName
	
	
	$ActivationText.text = textToDisplay
	ShowMyStuff()
	$ExistenceTimer.start()
	timerStarted = true
