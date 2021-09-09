extends Control


#read and edit the stuff in the settings folder and use it's values to
#set values in the settings singleton(global class values like GameSate)

func _ready():
	pass


func _on_BackButton_pressed():
	get_tree().change_scene("res://Game/Scenes/Main/MainMenuAndSubMenus/MainMenu.tscn")


func _on_SaveChangesButton_pressed():
	#save the changes to the text file and the script
	pass # Replace with function body.
