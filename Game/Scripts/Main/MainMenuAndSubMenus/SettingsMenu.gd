extends Control


#read and edit the stuff in the settings folder and use it's values to
#set values in the settings singleton(global class values like GameSate)

func _ready():
	var returnedVals = MusicManager.GetCurrentMenuMusic()	#first is music, second is position in song
	var song = returnedVals[0]
	var songPos = returnedVals[1]
	$MenuMusic.stream = song
	$MenuMusic.play(songPos)


func _on_BackButton_pressed():
	MusicManager.SetMenuMusicPlaybackPosition($MenuMusic.get_playback_position())
	get_tree().change_scene("res://Game/Scenes/Main/MainMenuAndSubMenus/MainMenu.tscn")


func _on_SaveChangesButton_pressed():
	#save the changes to the text file and the script
	pass # Replace with function body.
