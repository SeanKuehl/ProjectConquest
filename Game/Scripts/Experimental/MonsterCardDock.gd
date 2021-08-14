extends KinematicBody2D
#this will store the animation for the monster
#and may move to do attacks/things for battle which is why it's a
#kinematic body 2d
onready var thisNode = get_node("../"+name)	#this may not work as it will be the child of a child of the root scene
#may need another ../ to reflect this

onready var animation = thisNode.get_node("Animation")
onready var centre = thisNode.get_node("Centre")

signal displayDockedMonster(cardName, cardPicture, cardDescription)

var monsterCardName = ""
var monsterCardPicture = ""
var monsterCardDescription = ""

var mouseIsInTile = false
var thereIsAMonsterDocked = false

func _ready():
	animation.global_position = centre.global_position


func get_input():
	if Input.is_action_pressed("CLICK") and mouseIsInTile and thereIsAMonsterDocked:
		#if there is no monster docked, there is nothing to do
		emit_signal("displayDockedMonster", monsterCardName, monsterCardPicture, monsterCardDescription)
		
	
	
		
	
		
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
		

	
func _physics_process(_delta):
	
	get_input()

func _on_MonsterCardDock_mouse_entered():
	mouseIsInTile = true


func _on_MonsterCardDock_mouse_exited():
	mouseIsInTile = false
