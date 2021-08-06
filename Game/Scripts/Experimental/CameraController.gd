extends Camera2D

var cameraMoveAmount = 25
var zoomX = 1
var zoomY = 1

func _ready():
	pass


func get_input():
	#space bar not available
	
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
	
	#forget rotating, it just has something to rotate with target
	#also I'd have to rotate the field and all the assets as well as the camera
	
	
	
	get_input()
