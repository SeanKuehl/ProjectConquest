extends Node

var menuPanelTheme = 0
var menuButtonTheme = 0

var menuButtonHoveredTheme = 0

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
