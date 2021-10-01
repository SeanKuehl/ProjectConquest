extends Control



func _ready():
	Settings.SetButtonToTheme($BackButton)
	Settings.SetPanelToTheme($Panel)
	
#	var returnedVals = MusicManager.GetCurrentMenuMusic()	#first is music, second is position in song
#	var song = returnedVals[0]
#	var songPos = returnedVals[1]
#	$MenuMusic.stream = song
#	$MenuMusic.play(songPos)


func _on_BackButton_pressed():
	#MusicManager.SetMenuMusicPlaybackPosition($MenuMusic.get_playback_position())
	get_tree().change_scene("res://Game/Scenes/Main/MainMenuAndSubMenus/MainMenu.tscn")
