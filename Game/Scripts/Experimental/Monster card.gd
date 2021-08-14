extends "res://Game/Scripts/Experimental/Card Experiment.gd"





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

var attributeLabel = ""
var healthLabel = ""


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
	colorBackgroundColor = load(colorSubDict["YELLOW"])
	pictureBackgroundColor = load(colorSubDict["BLACK"])
	descriptionOrEffectBackgroundColor = load(colorSubDict["BLACK"])

	
#	var content = ReadLinesFromFile("res://Game/Assets/Card Files/Experimental.txt")
#
#	cardName = content[0]	
#	nameLabel.text = cardName
#
#	cardDescription = content[2]
#	descriptionOrEffectLabel.text = cardDescription
#
#	#for x in content:
#		#print(x)
#
#	#load the image
#	cardPicture = content[1]
#	var image = load("res://Game/Assets/Images/Experimental/"+cardPicture)
#	cardPicture = image	#this is for later when it's passed to the cardDisplay
#
#	picture.texture = image
#	#actual pic is texture property
#	#it's just highlighting, which may be why it doesn't work on black
#
#	#set background colors
#	baseBackground.texture = baseBackgroundColor
#	colorBackground.texture = colorBackgroundColor
#	pictureBackground.texture = pictureBackgroundColor
#	descriptionOrEffectBackground.texture = descriptionOrEffectBackgroundColor

	
	
	
	#var new_position = get_global_mouse_position()
	#movement = new_position - position;
	
func init(passedFile, passedOwner):
	
	var content = ReadLinesFromFile(passedFile)
	#this is now the child of the root scene so it's no longer direct children
	
	
	cardOwner = passedOwner
	
	cardName = content[0]	
	
	nameLabel.text = cardName
	
	#this will change because there could actually be an effect
	cardDescription = content[2]
	
	#testmonstersound.ogg
	#testmonsteranimation_01.png
	#res://Game/Scripts/card scripts/monster card scripts/testmonstercardscript.gd
	
	
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
	descriptionOrEffectLabel.text = attacksAsTextToDisplay
	
	#res://Game/Scripts/card scripts/location card scripts/testlocationscript.gd
	#testlocationscript.gd
	#var new_position = get_global_mouse_position()
	#movement = new_position - position;
	
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
	

func GetAnimation():
	return animation

	
func _physics_process(_delta):
	#I'm only putting it in here so it constantly checks
	
	var newPos = get_global_mouse_position()
	#position = position.move_toward(newPos, delta * moveSpeed)
	if clickedAndDraggedOn:
		position = newPos
	
	
	
	get_input()
   
	



func _on_Card_mouse_entered():
	
	mouseIsInTile = true


func _on_Card_mouse_exited():
	
	mouseIsInTile = false
