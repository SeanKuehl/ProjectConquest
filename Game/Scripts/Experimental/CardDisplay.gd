extends Control

onready var nameLabel = $Name
onready var descriptionOrEffectLabel = $ScrollContainer/DescriptionOrEffect
onready var picture = $Picture/Red
#these $ things work on this but not on the cards because this node isn't instanced



func _ready():
	#baseCard.connect("userWantsToDisplayCard", self, "DisplayCard")
	#I need the thing that is making the signal to connect itself here
	pass
	
	

	
func ConnectCardSignal(card):
	card.connect("userWantsToDisplayCard", self, "DisplayCard")
	card.connect("userWantsToDisplayMonsterCard", self, "DisplayMonsterCard")
	card.connect("userWantsToDisplayBattleCard", self, "DisplayBattleCard")
	
	
func ConnectMonsterDockSignal(dock):
	dock.connect("displayDockedMonster", self, "DisplayCard")
	
func DisplayCard(cardName, cardPicture, cardDescription):
	nameLabel.text = cardName
	descriptionOrEffectLabel.text = cardDescription
	
	picture.texture = cardPicture

func DisplayMonsterCard(cardName, cardPicture, cardDescription, cardHealth, cardAttribute):
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

func DisplayBattleCard(cardName, cardPicture, cardDescription, cardAttribute):
	nameLabel.text = cardName
	
	var descriptionText = ""
	
	
	#add card attribute and space after to description
	descriptionText += "Attribute: "+cardAttribute
	descriptionText += "\n"
	
	
	
	#add the rest of the description
	descriptionText += cardDescription
	
	descriptionOrEffectLabel.text = descriptionText
	
	picture.texture = cardPicture


	
