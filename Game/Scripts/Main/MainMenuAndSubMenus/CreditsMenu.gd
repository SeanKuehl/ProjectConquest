extends Control



func _ready():
	pass


func _on_BackButton_pressed():
	get_tree().change_scene("res://Game/Scenes/Main/MainMenuAndSubMenus/MainMenu.tscn")
