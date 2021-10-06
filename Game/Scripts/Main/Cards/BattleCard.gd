extends "res://Game/Scripts/Main/Cards/BaseCardClass.gd"




var customScript = ""
var customScriptDirectory = "res://Game/Scripts/card scripts/battle card scripts/"
var cardEffect = ""
var parent = 0
var isDocked = false
var priority = -1	
var attribute = ""
	



func _ready():
	cardType = "Battle"	#this would be 'location' or 'battle'



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
	colorBackgroundColor = load(colorSubDict["BLUE"])
	pictureBackgroundColor = load(colorSubDict["RED"])
	descriptionOrEffectBackgroundColor = load(colorSubDict["BLACK"])

	
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
	

#filteredVersion is a battle card before it's been filtered by all active cards
#it's in the form: [attribute, true] where attribute is the attribute of the card and true is whether or not the card is allowed to be played
func BattleCardFilter(battleCardToFilter):
	return customScript.FilterBattleCard(battleCardToFilter)
	
#monsterData, this is info from a monster card in the form [attribute, health] where it's the actual attribute and health values
func MonsterDataFilter(monsterData):
	return customScript.FilterMonsterData(monsterData)
	
#filteredVersion is a battle card after it's been filtered by all active cards
#it's in the form: [attribute, true] where attribute is the attribute of the card and true is whether or not the card is allowed to be played
func ActivateEffect(filteredVersion):
	customScript.Effect(filteredVersion)

func GetFilterData():
	#attribute and whether or not the effect are allowed are all that 
	#can really be changed about a battle card
	return [attribute, true]
	
	
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
	
	
	cardIsDocked = false
	
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
		
		
		var tempDescription = cardDescription
		
		#max amount of chars in effect/description before overflow is 225(len of the string)
		#this only applied visually on the card, it can be as long as it wants in card display because it can scroll
		var maxAmountOfCharsInDesc = 225
		if len(tempDescription) > maxAmountOfCharsInDesc:
			tempDescription.erase(maxAmountOfCharsInDesc, len(tempDescription)-maxAmountOfCharsInDesc)	#from the max chars points, erase as many chars as needed to cut the string down to max size
			tempDescription[-3] = '.'
			tempDescription[-2] = '.'
			tempDescription[-1] = '.'	#make the last three characters '...'
		
		
		
		
		descriptionOrEffectLabel.text = tempDescription
		customScript = content[4]
	else:
		
		var effect = ""
		var effectLinesStartIndex = 4
		var customScriptIndex = 4
		for x in range(effectLinesStartIndex,effectLinesStartIndex+numberOfEffectLines):
			effect += content[x] + " "	
			customScriptIndex += 1
		
		customScript = content[customScriptIndex]
		
		attribute = content[customScriptIndex+1]
		
		
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

	
	
	
func get_input():
	if Input.is_action_pressed("CLICK") and mouseIsInTile:
		if GameState.GetCardWasSelected() == false:
			clickedAndDraggedOn = true
			GameState.SetCardWasSelected(true)
		else:
			#don't let the card be dragged
			pass
		
	
	if Input.is_action_just_released("CLICK"):
		clickedAndDraggedOn = false
		GameState.SetCardWasSelected(false)
		
	if Input.is_action_just_pressed("RIGHT_CLICK") and mouseIsInTile:
		emit_signal("userWantsToDisplayBattleCard", cardName, cardPicture, cardDescription, attribute)
	
	

	
func _physics_process(_delta):
	#I'm only putting it in here so it constantly checks
	
	var newPos = get_global_mouse_position()
	
	if clickedAndDraggedOn:
		position = newPos
		
		
	
	
	
	
	get_input()
   
	



func _on_Card_mouse_entered():
	
	mouseIsInTile = true


func _on_Card_mouse_exited():
	
	mouseIsInTile = false
