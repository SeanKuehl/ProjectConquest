extends Node

var menuPanelTheme = 0
var menuButtonTheme = 0

var menuButtonHoveredTheme = 0

var systemVolume = 0

var settingsFilePath = "res://Game/Assets/SettingsFolder/Settings.txt"


func GetListOfSettings():
	var listOfSettings = []
	listOfSettings.append(systemVolume)
	
	return listOfSettings

func GetSettingsFilePath():
	return settingsFilePath

func GetSystemVolume():
	return systemVolume
	
func SetSystemVolume(newVal):
	systemVolume = newVal


func _ready():
	
	
	menuPanelTheme = StyleBoxFlat.new()
	menuPanelTheme.bg_color = Color(0.162048, 0.381236, 0.691406)	#blue
	
	menuButtonTheme = StyleBoxFlat.new()
	menuButtonTheme.bg_color = Color(0.792157, 0.505882, 0.062745)	#orange
	
	menuButtonHoveredTheme = StyleBoxFlat.new()
	menuButtonHoveredTheme.bg_color = Color(0.570313, 0.277951, 0.064606)	#darker orange
	
	
	
	
	
func SetButtonToTheme(button):
	button.set("custom_styles/normal", menuButtonTheme)
	button.set("custom_styles/hover", menuButtonHoveredTheme)
	button.set("custom_styles/pressed", menuButtonTheme)
	button.set("custom_styles/focus", menuButtonTheme)
	button.set("custom_styles/disabled", menuButtonTheme)
	
func SetPanelToTheme(panel):
	panel.set("custom_styles/panel", menuPanelTheme)


func GetSettingsFromFile():
	
	var file = File.new()
	file.open(settingsFilePath, File.READ)
	var content = []
	#check for empty lines! reading etc the file will add an empty line onto the end of it
	var line = ""
	while file.eof_reached() == false:
		line = file.get_line()
		if line == "":
			#it's an empty line, ignore it
			pass
		else:
			content.append(line)
			
	file.close()
	
	return content
	
	
func SetSettings():
	var settingsFileContent = GetSettingsFromFile()
	
	var soundVolumeSettings = int(settingsFileContent[0])
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), soundVolumeSettings)
	systemVolume = soundVolumeSettings


