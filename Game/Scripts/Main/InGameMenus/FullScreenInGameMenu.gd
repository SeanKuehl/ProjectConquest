extends CanvasLayer


func _ready():
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
