extends Control


#read and edit the stuff in the settings folder and use it's values to
#set values in the settings singleton(global class values like GameSate)

var localVolume = 0
var upperVolumeLimit = 15
var lowerVolumeLimit = -30
var isMute = false

func _ready():
	Settings.SetButtonToTheme($BackButton)
	Settings.SetButtonToTheme($SaveChangesButton)
	Settings.SetPanelToTheme($Panel)

	localVolume = Settings.GetSystemVolume()

	if localVolume == -100:
		#it's muted
		localVolume = 0
		isMute = true
		$MuteButton.text = "Unmute"
		$SoundVolume.text = "System Volume: "+str(localVolume)
	else:
		$SoundVolume.text = "System Volume: "+str(localVolume)

	#print(AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Master")))
	#AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), 10)

	var returnedVals = MusicManager.GetCurrentMenuMusic()	#first is music, second is position in song
	var song = returnedVals[0]
	var songPos = returnedVals[1]
	$MenuMusic.stream = song
	$MenuMusic.play(songPos)
	#AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), 0)
	#AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Master"))
	#zero(0) is the default volume


func _on_BackButton_pressed():
	MusicManager.SetMenuMusicPlaybackPosition($MenuMusic.get_playback_position())
	get_tree().change_scene("res://Game/Scenes/Main/MainMenuAndSubMenus/MainMenu.tscn")


func _on_SaveChangesButton_pressed():
	if isMute:
		Settings.SetSystemVolume(-100)	#-100 is beyond the min of -30, so it's the indicator that they want it muted
	else:
		Settings.SetSystemVolume(localVolume)
	var file = File.new()
	file.open(Settings.GetSettingsFilePath(), File.WRITE)


	for line in Settings.GetListOfSettings():
		file.store_string(str(line))

	file.close()
	#save the changes to the text file and the script

	MusicManager.SetMenuMusicPlaybackPosition($MenuMusic.get_playback_position())
	get_tree().change_scene("res://Game/Scenes/Main/MainMenuAndSubMenus/MainMenu.tscn")




func _on_SoundVolumeUp_pressed():
	if localVolume == upperVolumeLimit:
		pass
	else:
		localVolume += 1
	$SoundVolume.text = "System Volume: "+str(localVolume)


	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), localVolume)



func _on_SoundVolumeDown_pressed():
	if localVolume == lowerVolumeLimit:
		pass
	else:
		localVolume -= 1
	$SoundVolume.text = "System Volume: "+str(localVolume)


	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), localVolume)



func _on_MuteButton_pressed():

	if isMute:
		#if it's muted, unmute it
		$MuteButton.text = "Mute"
		AudioServer.set_bus_mute(AudioServer.get_bus_index("Master"), false)
		isMute = false
	else:
		#if it's unmuted, mute it
		$MuteButton.text = "Unmute"

		AudioServer.set_bus_mute(AudioServer.get_bus_index("Master"), true)
		isMute = true

