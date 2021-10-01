extends Control

var firstTimeCalled = true

func _ready():
	
	Settings.SetButtonToTheme($QuitButton)
	Settings.SetButtonToTheme($CreditsButton)
	Settings.SetButtonToTheme($SettingsButton)
	Settings.SetButtonToTheme($PlayButton)
	Settings.SetButtonToTheme($BrowseCardsButton)
	Settings.SetPanelToTheme($Panel)
	
	
#	if firstTimeCalled:
#		MusicManager.LoadMusic()	#only need to call this once
#		firstTimeCalled = false
#
#
#	var returnedVals = MusicManager.GetCurrentMenuMusic()	#first is music, second is position in song
#	var song = returnedVals[0]
#	var songPos = returnedVals[1]
#	$MenuMusic.stream = song
#	$MenuMusic.play(songPos)


func _on_QuitButton_pressed():
	get_tree().quit()	#exit the game


func _on_CreditsButton_pressed():
	MusicManager.SetMenuMusicPlaybackPosition($MenuMusic.get_playback_position())
	get_tree().change_scene("res://Game/Scenes/Main/MainMenuAndSubMenus/CreditsMenu.tscn")


func _on_SettingsButton_pressed():
	MusicManager.SetMenuMusicPlaybackPosition($MenuMusic.get_playback_position())
	get_tree().change_scene("res://Game/Scenes/Main/MainMenuAndSubMenus/SettingsMenu.tscn")



func _on_PlayButton_pressed():
	DeckMenuHelper.SetPlayersSelectingDecksForBattle(true)
	
	#get_tree().change_scene("res://Game/Scenes/Main/Root.tscn")
	MusicManager.SetMenuMusicPlaybackPosition($MenuMusic.get_playback_position())
	get_tree().change_scene("res://Game/Scenes/Main/DeckMenus/DisplayDecksMenu.tscn")


func _on_BrowseCardsButton_pressed():
	MusicManager.SetMenuMusicPlaybackPosition($MenuMusic.get_playback_position())
	get_tree().change_scene("res://Game/Scenes/Main/DeckMenus/DisplayDecksMenu.tscn")
