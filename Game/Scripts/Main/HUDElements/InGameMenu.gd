extends CanvasLayer


func _ready():
	Settings.SetButtonToTheme($Button)



func _on_Button_pressed():
	get_parent().ShowFullScreenInGameMenu()
