extends "res://Game/Scripts/Experimental/Card Experiment.gd"




var customScript = ""
var customScriptDirectory = "res://Game/Scripts/card scripts/location card scripts/"
var cardEffect = ""
var parent = 0
var isDocked = false
var priority = -1	



	#this is used for connecting signals from the root scene to the custom script
#signals: battle started, battle card played, battle ended



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

func GetPriority():
	return priority
	
func SetPriority(newPriority):
	priority = newPriority
	
func FilterAttack(attack):
	return customScript.Filter(attack)
	
func BattleCardFilter(battleCardToFilter):
	return customScript.FilterBattleCard(battleCardToFilter)
	
func GetIsDocked():
	return isDocked
	
func SetIsDocked(dockedStatus):
	isDocked = dockedStatus
	
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
		descriptionOrEffectLabel.text = cardDescription
		customScript = content[4]
	else:
		
		var effect = ""
		var effectLinesStartIndex = 4
		var customScriptIndex = 4
		for x in range(effectLinesStartIndex,effectLinesStartIndex+numberOfEffectLines):
			effect += content[x]
			customScriptIndex += 1
			
		customScript = content[customScriptIndex]
		cardDescription = effect	#this is required because the signal to the display sends cardDescription and not effect
		descriptionOrEffectLabel.text = effect
		cardEffect = effect
		customScript = load(customScriptDirectory+customScript)
		customScript = customScript.new()
		#customScript.ConnectSignalsFromRoot(parent)
	
	#set background colors
	baseBackground.texture = baseBackgroundColor
	colorBackground.texture = colorBackgroundColor
	pictureBackground.texture = pictureBackgroundColor
	descriptionOrEffectBackground.texture = descriptionOrEffectBackgroundColor

	
	#res://Game/Scripts/card scripts/location card scripts/testlocationscript.gd
	#testlocationscript.gd
	#var new_position = get_global_mouse_position()
	#movement = new_position - position;
	

	

	
func _physics_process(_delta):
	#I'm only putting it in here so it constantly checks
	
	var newPos = get_global_mouse_position()
	#position = position.move_toward(newPos, delta * moveSpeed)
	if clickedAndDraggedOn:
		position = newPos
	
	
	
	get_input()
   
	
func ConnectCustomScriptToLocationDockSignal(dock):
	customScript.ConnectSignalsFromLocationDock(dock)


func _on_Card_mouse_entered():
	
	mouseIsInTile = true
		


func _on_Card_mouse_exited():
	
	mouseIsInTile = false
	



