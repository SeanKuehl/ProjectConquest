extends KinematicBody2D


var mouseIsInTile = false
var temp = false

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
		
	$name.text = content[0]
	$description.text = content[2]
	#for x in content:
		#print(x)
	
	#load the image
	var image = load("res://Game/Assets/Images/Experimental/"+content[1])
	
	$Sprite2/secondSample.texture = image
	#actual pic is texture property
	
	
	
	#var new_position = get_global_mouse_position()
	#movement = new_position - position;
	
func get_input():
	if Input.is_action_pressed("CLICK") and mouseIsInTile:
		temp = true
	if Input.is_action_just_released("CLICK"):
		temp = false
		
	
	
	if Input.is_action_just_pressed("SPACE"):
		scale = Vector2(1.5, 1.5)	#this scales the kinematic body2d and all of it's children
		#if it's a property of kinematic body 2d you can use it like this and it should effect everything
		
		
	
func _physics_process(_delta):
	#I'm only putting it in here so it constantly checks
	
	var newPos = get_global_mouse_position()
	#position = position.move_toward(newPos, delta * moveSpeed)
	if temp:
		position = newPos
	
	get_input()
   
	



func _on_Card_mouse_entered():
	#remember to turn on "pickable" in the editor or this won't work!
	mouseIsInTile = true


func _on_Card_mouse_exited():
	
	mouseIsInTile = false
