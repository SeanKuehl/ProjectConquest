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
	
func ConnectMonsterDockSignal(dock):
	dock.connect("displayDockedMonster", self, "DisplayCard")
	
func DisplayCard(cardName, cardPicture, cardDescription):
	nameLabel.text = cardName
	descriptionOrEffectLabel.text = cardDescription
	
	picture.texture = cardPicture



	
