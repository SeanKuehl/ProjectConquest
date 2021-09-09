extends Control


func _ready():
	pass


func _on_QuitButton_pressed():
	get_tree().quit()	#exit the game


func _on_CreditsButton_pressed():
	get_tree().change_scene("res://Game/Scenes/Main/MainMenuAndSubMenus/CreditsMenu.tscn")


func _on_SettingsButton_pressed():
	get_tree().change_scene("res://Game/Scenes/Main/MainMenuAndSubMenus/SettingsMenu.tscn")



func _on_PlayButton_pressed():
	get_tree().change_scene("res://Game/Scenes/Main/Root.tscn")


func _on_BrowseCardsButton_pressed():
	get_tree().change_scene("res://Game/Scenes/Main/MainMenuAndSubMenus/BrowseCardsMenuFolder/BrowseCardsMenu.tscn")
