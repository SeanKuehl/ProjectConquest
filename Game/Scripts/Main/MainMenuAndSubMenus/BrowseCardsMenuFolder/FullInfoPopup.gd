extends CanvasLayer


func _ready():
	HideMyStuff()
	
	
func HideMyStuff():
	$Panel.hide()
	$Name.hide()
	$Picture/Blue.hide()
	$Picture.hide()
	$ScrollContainer.hide()
	$ScrollContainer/EffectDescription.hide()
	
func ShowMyStuff():
	$Panel.show()
	$Name.show()
	$Picture/Blue.show()
	$Picture.show()
	$ScrollContainer.show()
	$ScrollContainer/EffectDescription.show()


func ConnectCardSignals(card):
	card.connect("ShowStrategyOrLocationCard", self, "DisplayLocationAndStrategyCard")
	card.connect("ShowBattleCard", self, "DisplayBattleCard")
	card.connect("ShowMonsterCard", self, "DisplayMonsterCard")
	card.connect("HideInfoDisplay", self, "HideMyStuff")
	
	

func DisplayLocationAndStrategyCard(cardName, cardDescription, cardPicture):
	ShowMyStuff()
	$Name.text = cardName
	$Picture/Blue.texture = cardPicture
	$ScrollContainer/EffectDescription.text = cardDescription
	
func DisplayBattleCard(cardName, cardDescription, cardPicture, attribute):
	ShowMyStuff()
	$Name.text = cardName
	$Picture/Blue.texture = cardPicture
	
	var effectText = ""
	effectText += "Attribute: "+str(attribute) + "\n"
	effectText += cardDescription
	
	$ScrollContainer/EffectDescription.text = effectText
	
func DisplayMonsterCard(cardName, cardDescription, cardPicture, attribute, health):
	ShowMyStuff()
	$Name.text = cardName
	$Picture/Blue.texture = cardPicture
	
	var effectText = ""
	effectText += "Attribute: "+str(attribute) + "\n"
	effectText += "Health: "+str(health) + "\n"
	#attacks are in the cardDescription
	effectText += cardDescription
	
	$ScrollContainer/EffectDescription.text = effectText
