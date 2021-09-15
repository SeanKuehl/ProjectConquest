extends CanvasLayer

var timerStarted = false

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
