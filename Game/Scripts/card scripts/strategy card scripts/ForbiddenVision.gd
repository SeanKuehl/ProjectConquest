extends Node


var numberOfTimesCalled = 0
var status = "not done"

func _ready():
	pass

#this cards effect is you get to see the information of any location card
#on the field(puts information into display)
	
func Preparation():
	if numberOfTimesCalled == 0:
		GameState.HandleStrategyCardMenuForCustomScript("Choose the card you would like to learn about.")
		numberOfTimesCalled += 1
		
	elif numberOfTimesCalled == 1:
		status = "Done"
		
	
		
		
	return status
	
func Effect():

	var values = GameState.GetStrategyPreparationValues()
	
	#get card at that index to emit_signal("userWantsToDisplayCard", cardName, cardPicture, cardDescription)
	GameState.DisplayLocationCardAtIndex(values[0])
	
	print("strategy card effect worked")
	
	
	return "Success"	#if the card effect could not be played/work, return "Fail"
	#this may happen if for instance the card effect moves a monster from one card to another
	#but neither passed location dock value has a monster docked in it
