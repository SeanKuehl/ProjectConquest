extends Control

var locationDockNumberToReturn = -1	#-1 in case something goes wrong, that way -1 will return an error where a 0 may have silently passed even though it's wrong
onready var textToShowUser = $TextPrompt

signal userMadeSelection()

func _ready():
	pass

func SetTextToShowUser(newText):
	textToShowUser.text = newText

func GetLocationDockToReturn():
	return locationDockNumberToReturn

func _on_LocationDockOneButton_pressed():
	#this is the real(not counting starting at zero) index of the location dock
	locationDockNumberToReturn = 1
	yield(get_tree(),"idle_frame")
	emit_signal("userMadeSelection")
	


func _on_LocationDockTwoButton_pressed():
	locationDockNumberToReturn = 2
	yield(get_tree(),"idle_frame")
	emit_signal("userMadeSelection")


func _on_LocationDockThreeButton_pressed():
	locationDockNumberToReturn = 3
	yield(get_tree(),"idle_frame")
	emit_signal("userMadeSelection")


func _on_LocationDockFourButton_pressed():
	locationDockNumberToReturn = 4
	yield(get_tree(),"idle_frame")
	emit_signal("userMadeSelection")


func _on_LocationDockFiveButton_pressed():
	locationDockNumberToReturn = 5
	yield(get_tree(),"idle_frame")
	emit_signal("userMadeSelection")


func _on_LocationDockSixButton_pressed():
	locationDockNumberToReturn = 6
	yield(get_tree(),"idle_frame")
	emit_signal("userMadeSelection")


func _on_LocationDockSevenButton_pressed():
	locationDockNumberToReturn = 7
	yield(get_tree(),"idle_frame")
	emit_signal("userMadeSelection")


func _on_LocationDockEightButton_pressed():
	locationDockNumberToReturn = 8
	yield(get_tree(),"idle_frame")
	emit_signal("userMadeSelection")


func _on_LocationDockNineButton_pressed():
	locationDockNumberToReturn = 9
	yield(get_tree(),"idle_frame")
	emit_signal("userMadeSelection")
