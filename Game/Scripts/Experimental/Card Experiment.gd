extends KinematicBody2D

#enemySprite.set_modulate(Color(59,2,2))
#to undo color thing: enemySprite.set_modulate(Color(1,1,1,1))
#I think last spot is alpha, could be used to get the solid change I want
var mouseIsInTile = false
var temp = false

var cardName = ""
var cardPicture = ""
var cardDescription = ""

var colorSubDict = {"RED": "res://Game/Assets/Images/Experimental/Red.png",
"BLUE": "res://Game/Assets/Images/Experimental/Blue.png",
"BLACK": "res://Game/Assets/Images/Experimental/Black.png"}

onready var baseBackground = $BaseBackground/Background
onready var colorBackground = $ColorBackground/sample
onready var pictureBackground = $PictureBackground/Background
onready var picture = $Picture/secondSample
onready var descriptionOrEffectBackground = $DescriptionOrEffectBackground/Background
onready var nameLabel = $Name
onready var descriptionOrEffectLabel = $DescriptionOrEffect

var baseBackgroundColor = load(colorSubDict["BLACK"])
var colorBackgroundColor = load(colorSubDict["BLUE"])
var pictureBackgroundColor = load(colorSubDict["RED"])
var descriptionOrEffectBackgroundColor = load(colorSubDict["BLACK"])

#modulate doesn't work for all colors in all ways, so I'm going to do things a little different




var cardOwner = ""	#this will eventually be "PlayerOne" or "PlayerTwo"
var clickedAndDraggedOn = false


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
	
	
	var content = ReadLinesFromFile("res://Game/Assets/Card Files/Experimental.txt")
	
	cardName = content[0]	
	nameLabel.text = cardName
	
	cardDescription = content[2]
	descriptionOrEffectLabel.text = cardDescription
	
	#for x in content:
		#print(x)
	
	#load the image
	cardPicture = content[1]
	var image = load("res://Game/Assets/Images/Experimental/"+cardPicture)
	
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
	
func get_input():
	if Input.is_action_pressed("CLICK") and mouseIsInTile:
		clickedAndDraggedOn = true
	if Input.is_action_just_released("CLICK"):
		clickedAndDraggedOn = false
		
	
	
	if Input.is_action_just_pressed("SPACE"):
		scale = Vector2(1.5, 1.5)	#this scales the kinematic body2d and all of it's children
		#if it's a property of kinematic body 2d you can use it like this and it should effect everything
		
		
	
func _physics_process(_delta):
	#I'm only putting it in here so it constantly checks
	
	var newPos = get_global_mouse_position()
	#position = position.move_toward(newPos, delta * moveSpeed)
	if clickedAndDraggedOn:
		position = newPos
	
	
	
	get_input()
   
	



func _on_Card_mouse_entered():
	#remember to turn on "pickable" in the editor or this won't work!
	mouseIsInTile = true


func _on_Card_mouse_exited():
	
	mouseIsInTile = false
