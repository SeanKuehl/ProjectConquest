extends CanvasLayer

#this is what is refered to elsewhere as "strategy card menu"


var locationDockNumberToReturn = -1	#-1 in case something goes wrong, that way -1 will return an error where a 0 may have silently passed even though it's wrong
onready var textToShowUser = $TextPrompt

signal userMadeSelection()

func _ready():


	Settings.SetButtonToTheme($LocationDockOneButton)
	Settings.SetButtonToTheme($LocationDockTwoButton)
	Settings.SetButtonToTheme($LocationDockThreeButton)
	Settings.SetButtonToTheme($LocationDockFourButton)
	Settings.SetButtonToTheme($LocationDockFiveButton)
	Settings.SetButtonToTheme($LocationDockSixButton)
	Settings.SetButtonToTheme($LocationDockSevenButton)
	Settings.SetButtonToTheme($LocationDockEightButton)
	Settings.SetButtonToTheme($LocationDockNineButton)
	Settings.SetPanelToTheme($Panel)
	HideMyStuff()


func ShowMyStuff():
	$Panel.show()
	$TextPrompt.show()
	$LocationDockOneButton.show()
	$LocationDockTwoButton.show()
	$LocationDockThreeButton.show()
	$LocationDockFourButton.show()
	$LocationDockFiveButton.show()
	$LocationDockSixButton.show()
	$LocationDockSevenButton.show()
	$LocationDockEightButton.show()
	$LocationDockNineButton.show()

func HideMyStuff():
	$Panel.hide()
	$TextPrompt.hide()
	$LocationDockOneButton.hide()
	$LocationDockTwoButton.hide()
	$LocationDockThreeButton.hide()
	$LocationDockFourButton.hide()
	$LocationDockFiveButton.hide()
	$LocationDockSixButton.hide()
	$LocationDockSevenButton.hide()
	$LocationDockEightButton.hide()
	$LocationDockNineButton.hide()

func SetTextToShowUser(newText):
	textToShowUser.text = newText

func GetLocationDockToReturn():
	return locationDockNumberToReturn

func SetLocationDockToReturn(newNum):
	locationDockNumberToReturn = newNum

func _on_LocationDockOneButton_pressed():

	#this is the real(not counting starting at zero) index of the location dock
	locationDockNumberToReturn = 1
	HideMyStuff()
	emit_signal("userMadeSelection", "signal")




func _on_LocationDockTwoButton_pressed():
	locationDockNumberToReturn = 2
	HideMyStuff()
	emit_signal("userMadeSelection", "signal")



func _on_LocationDockThreeButton_pressed():
	locationDockNumberToReturn = 3
	HideMyStuff()
	emit_signal("userMadeSelection", "signal")




func _on_LocationDockFourButton_pressed():
	locationDockNumberToReturn = 4
	HideMyStuff()
	emit_signal("userMadeSelection", "signal")




func _on_LocationDockFiveButton_pressed():
	locationDockNumberToReturn = 5
	HideMyStuff()
	emit_signal("userMadeSelection", "signal")




func _on_LocationDockSixButton_pressed():
	locationDockNumberToReturn = 6
	HideMyStuff()
	emit_signal("userMadeSelection", "signal")




func _on_LocationDockSevenButton_pressed():
	locationDockNumberToReturn = 7
	HideMyStuff()
	emit_signal("userMadeSelection", "signal")




func _on_LocationDockEightButton_pressed():
	locationDockNumberToReturn = 8
	HideMyStuff()
	emit_signal("userMadeSelection", "signal")




func _on_LocationDockNineButton_pressed():
	locationDockNumberToReturn = 9
	HideMyStuff()
	emit_signal("userMadeSelection", "signal")





