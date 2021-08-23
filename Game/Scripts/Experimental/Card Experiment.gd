extends KinematicBody2D

#enemySprite.set_modulate(Color(59,2,2))
#to undo color thing: enemySprite.set_modulate(Color(1,1,1,1))
#I think last spot is alpha, could be used to get the solid change I want
var mouseIsInTile = false
var temp = false


signal userWantsToDisplayCard(cardName, cardPicture, cardDescription)

var cardIsDocked = false
var dockNumber = 0 
var cardType = "Base"	#this would be 'location' or 'battle'
var cardName = ""
var cardPicture = ""
var cardDescription = ""
var iAmBeingDragged = false

var colorSubDict = {"RED": "res://Game/Assets/Images/Experimental/Red.png",
"BLUE": "res://Game/Assets/Images/Experimental/Blue.png",
"BLACK": "res://Game/Assets/Images/Experimental/Black.png",
"YELLOW": "res://Game/Assets/Images/Experimental/Yellow.png"}


onready var thisNode = get_node("../"+name)	#get this node based on it's name, .. handles that there's a parent
#name in this case is the name of the node, even if it is auto renamed when added to this tree this should still get this node

#when I instance the node, I'd have to set it's get_node() name and pass it in so the card
#can access it's own children

onready var baseBackground = thisNode.get_node("BaseBackground/Background")
onready var colorBackground = thisNode.get_node("ColorBackground/sample")
onready var pictureBackground = thisNode.get_node("PictureBackground/Background")
onready var picture = thisNode.get_node("Picture/secondSample")
onready var descriptionOrEffectBackground = thisNode.get_node("DescriptionOrEffectBackground/Background")
onready var nameLabel = thisNode.get_node("Name")
onready var descriptionOrEffectLabel = thisNode.get_node("DescriptionOrEffect")


var baseBackgroundColor = load(colorSubDict["BLACK"])
var colorBackgroundColor = load(colorSubDict["BLUE"])
var pictureBackgroundColor = load(colorSubDict["RED"])
var descriptionOrEffectBackgroundColor = load(colorSubDict["BLACK"])

#modulate doesn't work for all colors in all ways, so I'm going to do things a little different




var cardOwner = ""	#this will eventually be "PlayerOne" or "PlayerTwo"
var clickedAndDraggedOn = false
var cardInvolvedInBattle = false

func ReadLinesFromFile(fileName):
	var file = File.new()
	file.open(fileName, File.READ)
	var content = []
	#check for empty lines! reading etc the file will add an empty line onto the end of it
	var line = ""
	while file.eof_reached() == false:
		line = file.get_line()
		if line == "":
			#it's an empty line, ignore it
			pass
		else:
			content.append(line)
			
	file.close()
	
	return content

func _ready():
	pass
	
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
	
	cardDescription = content[2]
	descriptionOrEffectLabel.text = cardDescription
	
	
	
	#load the image
	cardPicture = content[1]
	var image = load("res://Game/Assets/Images/Experimental/"+cardPicture)
	cardPicture = image	#this is for later when it's passed to the cardDisplay
	
	picture.texture = image
	#actual pic is texture property
	#it's just highlighting, which may be why it doesn't work on black
	
	#set background colors
	baseBackground.texture = baseBackgroundColor
	colorBackground.texture = colorBackgroundColor
	pictureBackground.texture = pictureBackgroundColor
	descriptionOrEffectBackground.texture = descriptionOrEffectBackgroundColor

	
	
	
	#var new_position = get_global_mouse_position()
	#movement = new_position - position;
	
func GetCardIsDocked():
	return cardIsDocked

func SetCardIsDocked(value):
	cardIsDocked = value
	
func GetCardInvolvedInBattle():
	return cardInvolvedInBattle
	
func SetCardInvolvedInBattle(newValue):
	cardInvolvedInBattle = newValue
	
func GetDockNumber():
	return dockNumber
	
func SetDockNumber(num):
	dockNumber = num
	
func SetCardType(value):
	cardType = value
	
func GetCardType():
	return cardType
	
func GetDisplayStuff():
	return [cardName, cardPicture, cardDescription]
	
	
func get_input():
	if Input.is_action_pressed("CLICK") and mouseIsInTile:
		clickedAndDraggedOn = true
	
	if Input.is_action_just_released("CLICK"):
		clickedAndDraggedOn = false
		
	if Input.is_action_just_pressed("RIGHT_CLICK"):
		emit_signal("userWantsToDisplayCard", cardName, cardPicture, cardDescription)
	
	
	if Input.is_action_just_pressed("SPACE"):
		scale = Vector2(1.5, 1.5)	#this scales the kinematic body2d and all of it's children
		#if it's a property of kinematic body 2d you can use it like this and it should effect everything
		
		
func GetClickAndDraggedOn():
	return clickedAndDraggedOn
	
func _physics_process(_delta):
	#I'm only putting it in here so it constantly checks
	
	var newPos = get_global_mouse_position()
	#position = position.move_toward(newPos, delta * moveSpeed)
	if clickedAndDraggedOn:
		position = newPos
	
	
	
	get_input()
   
	


func here():
	print("here")

func GetCardOwner():
	return cardOwner


func _on_Card_mouse_entered():
	
	mouseIsInTile = true


func _on_Card_mouse_exited():
	
	mouseIsInTile = false
