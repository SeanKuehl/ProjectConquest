extends CanvasLayer


func _ready():
	Settings.SetButtonToTheme($BackButton)
	Settings.SetButtonToTheme($QuitButton)
	Settings.SetPanelToTheme($Panel)
	
	HideMyStuff()


func HideMyStuff():
	$Panel.hide()
	$QuitButton.hide()
	$BackButton.hide()
	
func ShowMyStuff():
	$Panel.show()
	$QuitButton.show()
	$BackButton.show()






func _on_QuitButton_pressed():
	get_tree().quit()	#exit the game


func _on_BackButton_pressed():
	HideMyStuff()
