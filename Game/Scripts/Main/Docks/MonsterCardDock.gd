extends KinematicBody2D
#this will store the animation for the monster
#and may move to do attacks/things for battle which is why it's a
#kinematic body 2d
onready var thisNode = get_node("../"+name)	#this may not work as it will be the child of a child of the root scene
#may need another ../ to reflect this

onready var animation = thisNode.get_node("Animation")
onready var centre = thisNode.get_node("Centre")
onready var ownership = thisNode.get_node("PlayerOwnershipIndicator")
onready var healthLabel = thisNode.get_node("HealthIndicator")

signal displayDockedMonster(cardName, cardPicture, cardDescription)

var monsterCardName = ""
var monsterCardPicture = ""
var monsterCardDescription = ""

var mouseIsInTile = false
var thereIsAMonsterDocked = false

func _ready():
	animation.global_position = centre.global_position

func SetPlayerOwnershipText(text):
	ownership.text = text

func get_input():
	
	#the left click to display docked monster isn't needed because the right click
	#triggers the monster card's signal to display which shows helath and attribute which means 
	#there is no need for this one(displayDockedMonster signal
	
	#NOTE: right clicking on the monster animation and having it display in the card display
	#is only possible because the card is invisible on the location of the animation and still checking for input
	#(has a running physics process)
	
	if Input.is_action_pressed("RIGHT_CLICK") and mouseIsInTile and thereIsAMonsterDocked and GameState.GetBattleState() == "MonsterAttackPhase":
		get_parent().RootShowMonsterAttackOptions()
		#get parent, call one of it's funcs with params to do stuff
	#if monster is right clicked on during the "MonsterAttackPhase" you can select it's attacks
		
	
	
func ClearMonsterCardData():
	
	monsterCardName = ""
	monsterCardPicture = ""
	monsterCardDescription = ""
	
	animation.stop()
	animation.frames = SpriteFrames.new()
	thereIsAMonsterDocked = false
	hide()
		
		
#card is a reference to a monster card
func LoadMonsterCardInformation(card):
	var displayStuff = card.GetDisplayStuff()	#list of cardname, pic and description
	#also need to get animation, probably pics or whole object?
	monsterCardName = displayStuff[0]
	monsterCardPicture = displayStuff[1]
	monsterCardDescription = displayStuff[2]
	
	var animationToCopy = card.GetAnimation()	
	var newAnimation : SpriteFrames = SpriteFrames.new()
	newAnimation.add_animation("first")
	newAnimation.add_frame("first", load("res://Game/Assets/Animations/monster animations/"+animationToCopy[0]), 0)
	newAnimation.add_frame("first", load("res://Game/Assets/Animations/monster animations/"+animationToCopy[1]), 1)
	newAnimation.add_frame("first", load("res://Game/Assets/Animations/monster animations/"+animationToCopy[2]), 2)
	#$animation.speed_scale = 0.5
	#$animation.global_position
	animation.frames = newAnimation
	#$animation.speed_scale = 0.5
	animation.play("first")
	
	thereIsAMonsterDocked = true
	show()

	
func _physics_process(_delta):
	
	if ownership.text == "Player One":
		healthLabel.text = "Health: "+ str(get_parent().GetMonsterHealth("PlayerOne"))
	elif ownership.text == "Player Two":
		healthLabel.text = "Health: "+ str(get_parent().GetMonsterHealth("PlayerTwo"))
	else:
		#ownership isn't set yet
		pass
	
	get_input()

func _on_MonsterCardDock_mouse_entered():
	mouseIsInTile = true


func _on_MonsterCardDock_mouse_exited():
	mouseIsInTile = false
