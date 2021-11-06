extends CanvasLayer

onready var nameLabel = $Name
onready var descriptionOrEffectLabel = $ScrollContainer/DescriptionOrEffect
onready var picture = $Picture/Red
onready var defaultPicture = load("res://Game/Assets/Images/Experimental/Red.png")




func _ready():

	pass

func HideMyStuff():
	$Panel.hide()
	$Name.hide()
	$Picture.hide()
	$Picture/Red.hide()
	$ScrollContainer/DescriptionOrEffect.hide()
	$ScrollContainer.hide()
	$HideButton.hide()

func ShowMyStuff():
	$Panel.show()
	$Name.show()
	$Picture.show()
	$Picture/Red.show()
	$ScrollContainer/DescriptionOrEffect.show()
	$ScrollContainer.show()
	$HideButton.show()

func ConnectHelpSignal(helpNode):
	helpNode.connect("ShowHelp", self, "ShowHelpOnDisplay")

func ConnectCardSignal(card):
	card.connect("userWantsToDisplayCard", self, "DisplayCard")
	card.connect("userWantsToDisplayMonsterCard", self, "DisplayMonsterCard")
	card.connect("userWantsToDisplayBattleCard", self, "DisplayBattleCard")

func ShowHelpOnDisplay(textToShow):
	ShowMyStuff()
	#first clear out whatever was there before
	ClearDisplay()

	nameLabel.text = "help"
	descriptionOrEffectLabel.text = textToShow

func ClearDisplay():
	picture.texture = defaultPicture
	nameLabel.text = ""
	descriptionOrEffectLabel.text = ""


func DisplayCard(cardName, cardPicture, cardDescription):
	ShowMyStuff()
	nameLabel.text = cardName
	descriptionOrEffectLabel.text = cardDescription

	picture.texture = cardPicture

#this function does extra work to show the extra information this card type has that the other two types of cards don't have
func DisplayMonsterCard(cardName, cardPicture, cardDescription, cardHealth, cardAttribute):
	ShowMyStuff()
	nameLabel.text = cardName

	var descriptionText = ""

	#add card health and space after to description
	descriptionText += "Health: "+str(cardHealth)
	descriptionText += "\n"

	#add card attribute and space after to description
	descriptionText += "Attribute: "+cardAttribute
	descriptionText += "\n"

	#add the rest of the description
	descriptionText += cardDescription

	descriptionOrEffectLabel.text = descriptionText

	picture.texture = cardPicture

#this function does extra work to show the extra information this card type has that the other two types of cards don't have
func DisplayBattleCard(cardName, cardPicture, cardDescription, cardAttribute):
	ShowMyStuff()
	nameLabel.text = cardName

	var descriptionText = ""


	#add card attribute and space after to description
	descriptionText += "Attribute: "+cardAttribute
	descriptionText += "\n"



	#add the rest of the description
	descriptionText += cardDescription

	descriptionOrEffectLabel.text = descriptionText

	picture.texture = cardPicture





func _on_HideButton_pressed():
	HideMyStuff()
