extends "res://Game/Scripts/Main/Cards/BaseCardClass.gd"




var customScript = ""
var customScriptDirectory = "res://Game/Scripts/card scripts/location card scripts/"
var cardEffect = ""
var parent = 0
var isDocked = false
var priority = -1






func _ready():
	cardType = "Location"	#this would be 'location' or 'battle'



	thisNode = get_node("../"+name)	#get this node based on it's name, .. handles that there's a parent
	#name in this case is the name of the node, even if it is auto renamed when added to this tree this should still get this node

	parent = thisNode.get_parent()

	#when I instance the node, I'd have to set it's get_node() name and pass it in so the card
	#can access it's own children

	baseBackground = thisNode.get_node("BaseBackground/Background")
	colorBackground = thisNode.get_node("ColorBackground/sample")
	pictureBackground = thisNode.get_node("PictureBackground/Background")
	picture = thisNode.get_node("Picture/secondSample")
	descriptionOrEffectBackground = thisNode.get_node("DescriptionOrEffectBackground/Background")
	nameLabel = thisNode.get_node("Name")
	descriptionOrEffectLabel = thisNode.get_node("DescriptionOrEffect")


	baseBackgroundColor = load(colorSubDict["BLACK"])
	colorBackgroundColor = load(colorSubDict["RED"])
	pictureBackgroundColor = load(colorSubDict["BLUE"])
	descriptionOrEffectBackgroundColor = load(colorSubDict["BLACK"])

#this is used by card effects that might not have easy access to signal
func DisplayCardInformation():
	emit_signal("userWantsToDisplayCard", cardName, cardPicture, cardDescription)

func GetCardEffect():
	return cardEffect

func GetPriority():
	return priority

func SetPriority(newPriority):
	priority = newPriority


#attack is a monster attack in the form: [1, "flaming Sting", 60, "Inferno", "there is a one in eight chance this attack does 100 damage", true, true]
#where the the information is: the index of the attack(first attack), name of the attack, damage of the attack, attribute of the attack, text effect of the attack, whether the effect is enabled, whether the attack is allowed
func FilterAttack(attack):
	return customScript.FilterMonsterAttack(attack)

#battleCardToFilter is [attribute, true] where the first is the attribute of the card(string) and the second is whether the card is allowed to be played
func BattleCardFilter(battleCardToFilter):
	return customScript.FilterBattleCard(battleCardToFilter)

#monsterData, this is info from a monster card in the form [attribute, health] where it's the actual attribute and health values
func MonsterDataFilter(monsterData):
	return customScript.FilterMonsterData(monsterData)

func GetIsDocked():
	return isDocked

func SetIsDocked(dockedStatus):
	isDocked = dockedStatus


#passedFile is the path to a text file
#passedOwner is "PlayerOne" or "PlayerTwo"
func init(passedFile, passedOwner):

	var content = ReadLinesFromFile(passedFile)
	#this is now the child of the root scene so it's no longer direct children

	cardOwner = passedOwner

	cardName = content[0]

	var nameMaxCharLength = 12		#'strategist's' seems to be the max

	if len(cardName) > nameMaxCharLength:
		var shortenedName = ""
		var charIndex = 0
		for x in cardName:
			if charIndex < nameMaxCharLength:
				shortenedName += x
			charIndex += 1
		#this will actually produce something one char less than the max,
		#add a '.' on the end to show that it continues
		shortenedName += "."

		nameLabel.text = shortenedName

	else:
		nameLabel.text = cardName

	#this will change because there could actually be an effect
	cardDescription = content[2]




	#load the image
	cardPicture = content[1]
	var image = load("res://Game/Assets/Images/Experimental/"+cardPicture)
	cardPicture = image	#this is for later when it's passed to the cardDisplay

	picture.texture = image
	#actual pic is texture property
	#it's just highlighting, which may be why it doesn't work on black

	var numberOfEffectLines = int(content[3])

	if numberOfEffectLines == 0:
		#there is no effect, show description


		#no need to filter description with the max chars code like effect
		#because description is only one line

		descriptionOrEffectLabel.text = cardDescription
		customScript = content[4]
	else:

		var effect = ""
		var effectLinesStartIndex = 4
		var customScriptIndex = 4
		for x in range(effectLinesStartIndex,effectLinesStartIndex+numberOfEffectLines):
			effect += content[x] + " "
			customScriptIndex += 1

		customScript = content[customScriptIndex]
		cardDescription = effect	#this is required because the signal to the display sends cardDescription and not effect
		cardEffect = effect

		#max amount of chars in effect/description before overflow is 225(len of the string)
		#this only applied visually on the card, it can be as long as it wants in card display because it can scroll
		var maxAmountOfCharsInEffect = 225
		if len(effect) > maxAmountOfCharsInEffect:
			effect.erase(maxAmountOfCharsInEffect, len(effect)-maxAmountOfCharsInEffect)	#from the max chars points, erase as many chars as needed to cut the string down to max size
			effect[-3] = '.'
			effect[-2] = '.'
			effect[-1] = '.'	#make the last three characters '...'



		descriptionOrEffectLabel.text = effect

		customScript = load(customScriptDirectory+customScript)
		customScript = customScript.new()
		#customScript.ConnectSignalsFromRoot(parent)

	#set background colors
	baseBackground.texture = baseBackgroundColor
	colorBackground.texture = colorBackgroundColor
	pictureBackground.texture = pictureBackgroundColor
	descriptionOrEffectBackground.texture = descriptionOrEffectBackgroundColor





func _physics_process(_delta):
	#I'm only putting it in here so it constantly checks

	var newPos = get_global_mouse_position()

	if clickedAndDraggedOn:
		position = newPos



	get_input()

#dock is a reference to a location card dock
func ConnectCustomScriptToLocationDockSignal(dock):
	customScript.ConnectSignalsFromLocationDock(dock)


func _on_Card_mouse_entered():

#if animation still playing, wait for it to finish before shrinking again
	if $CardAnimationPlayer.is_playing() == false:
		$CardAnimationPlayer.play("HoverGrow")

		growAnimation = true



	mouseIsInTile = true


func _on_Card_mouse_exited():


	if $CardAnimationPlayer.is_playing() == false:
		growAnimation = false
		$CardAnimationPlayer.play("HoverShrink")



	mouseIsInTile = false





func _on_CardAnimationPlayer_animation_finished(anim_name):
	if mouseIsInTile == false and growAnimation:
		growAnimation = false
		$CardAnimationPlayer.play("HoverShrink")


