extends Camera2D

var cameraMoveAmount = 25
var zoomX = 1
var zoomY = 1

#these are arbitrary coordinates 
var maxX = 930
var minX = -530
var maxY = 300
var minY = -770

func _ready():
	pass


func get_input():
	
	
	#you use WASD to control the camera
	#Q is zoom in E is zoom out
	
	if Input.is_action_pressed("CAM_RIGHT"):
		position += transform.x * cameraMoveAmount
	
	if Input.is_action_pressed("CAM_LEFT"):
		position -= transform.x * cameraMoveAmount
		
	if Input.is_action_pressed("CAM_UP"):
		position -= transform.y * cameraMoveAmount
		
	if Input.is_action_pressed("CAM_DOWN"):
		position += transform.y * cameraMoveAmount
		
	if Input.is_action_pressed("ZOOM_IN"):
		zoomX -= 0.1
		zoomY -= 0.1
		zoom = Vector2(zoomX,zoomY)
	
	if Input.is_action_pressed("ZOOM_OUT"):
		zoomX += 0.1
		zoomY += 0.1
		zoom = Vector2(zoomX,zoomY)	#2,2 is an example of zoom out
	
		
	
func _physics_process(_delta):
	#it has zoom property, setting to a vector2(1,1)
	#values larger than 1,1 zoom out and smaller zoom in
	
	#this will keep the camera within a certain range
	position.x = clamp(position.x, minX, maxX)
	position.y = clamp(position.y, minY, maxY)
	
	
	get_input()
