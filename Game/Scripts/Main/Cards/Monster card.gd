extends "res://Game/Scripts/Main/Cards/BaseCardClass.gd"





var customScript = ""
var customScriptDirectory = "res://Game/Scripts/card scripts/monster card scripts/"
var cardEffect = ""
var parent = 0
	#this is used for connecting signals from the root scene to the custom script
#signals: battle started, battle card played, battle ended

var attribute = ""
var health = 0
var attacks = []
var sound = ""
var animation = []

var inUsedPile = false

var attributeLabel = ""
var healthLabel = ""

var damageTaken = 0


func _ready():
	cardType = "Monster"	#this would be 'location' or 'battle'



	thisNode = get_node("../"+name)	#get this node based on it's name, .. handles that there's a parent
	#name in this case is the name of the node, even if it is auto renamed when added to this tree this should still get this node

	parent = thisNode.get_parent()

	#when I instance the node, I'd have to set it's get_node() name and pass it in so the card
	#can access it's own children
	cardIsDocked = false

	baseBackground = thisNode.get_node("BaseBackground/Background")
	colorBackground = thisNode.get_node("ColorBackground/sample")
	pictureBackground = thisNode.get_node("PictureBackground/Background")
	picture = thisNode.get_node("Picture/secondSample")
	descriptionOrEffectBackground = thisNode.get_node("DescriptionOrEffectBackground/Background")
	nameLabel = thisNode.get_node("Name")
	descriptionOrEffectLabel = thisNode.get_node("DescriptionOrEffect")
	attributeLabel = thisNode.get_node("attribute")
	healthLabel = thisNode.get_node("health")


	baseBackgroundColor = load(colorSubDict["BLACK"])
	colorBackgroundColor = load(colorSubDict["GREEN"])
	pictureBackgroundColor = load(colorSubDict["BLACK"])
	descriptionOrEffectBackgroundColor = load(colorSubDict["BLACK"])

	

	
func GetInUsedPile():
	return inUsedPile
	
func SetInUsedPile(newVal):
	inUsedPile = newVal
	
	
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
	
	attribute = content[3]
	attributeLabel.text = attribute
	
	health = content[4]
	healthLabel.text = health+"hp"
	
	var numberOfAttacks = int(content[5])
	
	var textFileIndex = 6
	attacks = []
	
	while numberOfAttacks > 0:
		#each attack is a number followed by that many lines of text
		
		var linesOfTextOfAttack = int(content[textFileIndex])
		
		var thisAttack = ""
		
		for x in range(textFileIndex+1, textFileIndex+linesOfTextOfAttack+1):
			#+1 because max is exclusive
			thisAttack += content[x]
			
		
		textFileIndex += linesOfTextOfAttack+1	#skip to the next line after the attack
		attacks.append(thisAttack)
		thisAttack = ""
		numberOfAttacks -= 1
		
	sound = content[textFileIndex]
	$SoundPlayer.stream = load("res://Game/Assets/Sounds/Monster sounds/"+sound)
	#$SoundPlayer.play()
	#the sound file must be set without loop under the import menu
	#and reimported
	#$SoundPlayer.stop()
	
	#get the three frames of animation
	var numberOfAnimationFrames = 3
	for x in range(textFileIndex+1, textFileIndex+numberOfAnimationFrames+1):
		#max is exclusive
		animation.append(content[x])
		
	
	textFileIndex+= numberOfAnimationFrames + 1
	
	customScript = load("res://Game/Scripts/card scripts/monster card scripts/"+content[textFileIndex])
	customScript = customScript.new()
	
	#set background colors
	baseBackground.texture = baseBackgroundColor
	colorBackground.texture = colorBackgroundColor
	pictureBackground.texture = pictureBackgroundColor
	descriptionOrEffectBackground.texture = descriptionOrEffectBackgroundColor

	#a monster card will always have attacks, so overwrite description
	var attacksAsTextToDisplay = ""
	for x in attacks:
		attacksAsTextToDisplay += x
	cardDescription = attacksAsTextToDisplay
	
	
	#max amount of chars in effect/description before overflow is 225(len of the string)
	#this only applied visually on the card, it can be as long as it wants in card display because it can scroll
	var maxAmountOfCharsInAttacks = 225
	if len(attacksAsTextToDisplay) > maxAmountOfCharsInAttacks:
		attacksAsTextToDisplay.erase(maxAmountOfCharsInAttacks, len(attacksAsTextToDisplay)-maxAmountOfCharsInAttacks)	#from the max chars points, erase as many chars as needed to cut the string down to max size
		attacksAsTextToDisplay[-3] = '.'
		attacksAsTextToDisplay[-2] = '.'
		attacksAsTextToDisplay[-1] = '.'	#make the last three characters '...'
	
	descriptionOrEffectLabel.text = attacksAsTextToDisplay
	
	
	
	#I can create a spriteFrames thing, add frames to it and then add
	#that to the animated sprite
	var newAnimation : SpriteFrames = SpriteFrames.new()
	newAnimation.add_animation("first")
	newAnimation.add_frame("first", load("res://Game/Assets/Animations/monster animations/"+animation[0]), 0)
	newAnimation.add_frame("first", load("res://Game/Assets/Animations/monster animations/"+animation[1]), 1)
	newAnimation.add_frame("first", load("res://Game/Assets/Animations/monster animations/"+animation[2]), 2)
	#$animation.speed_scale = 0.5
	#$animation.global_position
	$animation.frames = newAnimation
	#$animation.play("first")
	
	
#returns a list of attacks where each attack is in the form: [1, "flaming Sting", 60, "Inferno", "there is a one in eight chance this attack does 100 damage", true, true]
#where the the information is: the index of the attack(first attack), name of the attack, damage of the attack, attribute of the attack, text effect of the attack, whether the effect is enabled, whether the attack is allowed
func GetAttacksToDisplay():
		
	return customScript.GetAttacksForDisplay()


#monsterAttack is in the form: [1, "flaming Sting", 60, "Inferno", "there is a one in eight chance this attack does 100 damage", true, true]
#see GetAttacksToDisplay's description for more information
func ActivateMonsterCardScriptEffect(monsterAttack):
	if monsterAttack[0] == 1:
		#do the first attack
		return customScript.FirstAttack(monsterAttack)
	elif monsterAttack[0] == 2:
		#do the second attack
		return customScript.SecondAttack(monsterAttack)
	elif monsterAttack[0] == 3:
		#do the third attack
		return customScript.ThirdAttack(monsterAttack)


#monsterAttack is in the form: [1, "flaming Sting", 60, "Inferno", "there is a one in eight chance this attack does 100 damage", true, true]
#see GetAttacksToDisplay's description for more information
#this function deals damage by taking away from the amount in the monster's health label
#it takes away from the amount in the label as opposed to the real health value so that the real
#value is never changed in a way that the monster's original stats can't be easily restored
func TakeDamage(monsterAttack):
	#use the health/attribute labels as the temp/battle values so that the user 
	#gets the right information while the original values are still present
	var damageToDo = monsterAttack[2]
	var newHealth = int(healthLabel.text)
	
	newHealth -= damageToDo
	damageTaken += damageToDo
	
	if newHealth < 0:
		newHealth = 0	#don't want to display a negative health
	
	healthLabel.text = str(newHealth)
	
func IncreaseHealth(value):
	
	var newHealth = int(healthLabel.text)
	
	newHealth += value
	
	
	damageTaken -= value
	
	if damageTaken < 0:
		damageTaken = 0
	
	
	
	healthLabel.text = str(newHealth)

func GetAnimation():
	return animation

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
		
		
	if Input.is_action_just_pressed("RIGHT_CLICK"):
		emit_signal("userWantsToDisplayMonsterCard", cardName, cardPicture, cardDescription, health, attribute)
	
	
	
func GetCardEffect():
	return cardEffect
	
func _physics_process(_delta):
	#I'm only putting it in here so it constantly checks
	
	var newPos = get_global_mouse_position()
	#position = position.move_toward(newPos, delta * moveSpeed)
	if clickedAndDraggedOn:
		position = newPos
	
	
	
	get_input()
   
#don't return the real health value, rather the one stored in the label that is effected by what happens in a battle
func GetBattleHealth():
	#this is the health stored inside the label that reflects changes due to things from battle like attacks
	return int(healthLabel.text)

func GetBattleAttribute():
	return attributeLabel.text

func GetData():
	#this is the original attribute and health, they will be filtered
	#by damage taken and all the active cards
	#then the 'battle' versions will be updated with the current information
	#damageTaken, this is a local var, filter it here before all the other things
	var healthToShow = int(health) - damageTaken
	return [attribute, healthToShow]
	#[attribute, health]
	
func SetData(newData):
	attributeLabel.text = str(newData[0])
	healthLabel.text = str(newData[1])
	
func ResetData():
	attributeLabel.text = attribute
	healthLabel.text = health
	damageTaken = 0


func _on_Card_mouse_entered():
	
	
	mouseIsInTile = true
		


func _on_Card_mouse_exited():
	
	mouseIsInTile = false
	



