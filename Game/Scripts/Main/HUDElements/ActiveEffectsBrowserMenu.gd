extends CanvasLayer


#this will get the list of active cards, get their names, types and descriptions
#and display then until the user wants to close the menu
var activeCardsInformationList = []	#an active card will be in here as [name, cardType, description]

onready var panel = $Panel
onready var prevButton = $Previouse
onready var nextButton = $Next
onready var nameAndTypeLabel = $NameAndType
onready var effectLabel = $ScrollContainer/Effect
onready var closeButton = $CloseButton
onready var effectContainer = $ScrollContainer

var currentListIndex = 0

func _ready():
	Settings.SetButtonToTheme($Next)
	Settings.SetButtonToTheme($Previouse)
	Settings.SetButtonToTheme($CloseButton)
	Settings.SetPanelToTheme($Panel)

	HideMyStuff()	#when first loaded into the scene, we don't want to block the screen


func HideMyStuff():
	panel.hide()
	prevButton.hide()
	nextButton.hide()
	nameAndTypeLabel.hide()
	effectLabel.hide()
	closeButton.hide()
	effectContainer.hide()

func SetInformation(index):
	var textForNameAndTypeLabel = ""
	var information = activeCardsInformationList[index]	#get a single entry, which is in the form [cardName, cardType, cardEffect]
	textForNameAndTypeLabel += "Name of card: "+information[0] + "\n"	#this is the name
	textForNameAndTypeLabel += "Type of card: "+information[1]	#this is the card type
	nameAndTypeLabel.text = textForNameAndTypeLabel

	effectLabel.text = information[2]	#this is the effect
	currentListIndex += 1	#this was the index passed in
	if currentListIndex > (len(activeCardsInformationList)-1):
		#if the index is greater than the real length of the list(current list index starts at zero)
		currentListIndex = 0	#set it back to zero
	else:
		pass

func ShowMyStuff():
	activeCardsInformationList = []
	activeCardsInformationList = GameState.GetActiveCardsInformation()
	panel.show()
	prevButton.show()
	nextButton.show()
	nameAndTypeLabel.show()
	effectLabel.show()
	closeButton.show()
	effectContainer.show()
	SetInformation(currentListIndex)




func _on_CloseButton_pressed():
	activeCardsInformationList = []
	currentListIndex = 0
	HideMyStuff()



func _on_Next_pressed():
	SetInformation(currentListIndex)	#set information increases current list index at it's end so you'll always be showing the 'next' one to the current one being displayed when you call it


func _on_Previouse_pressed():
	SetInformation(currentListIndex)
