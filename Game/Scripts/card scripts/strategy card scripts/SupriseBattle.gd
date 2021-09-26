extends Node


var numberOfTimesCalled = 0
var status = "not done"

func _ready():
	pass

#this card effect is to swap two location cards in their dock positions
	
func Preparation():
	if numberOfTimesCalled == 0:
		GameState.HandleStrategyCardMenuForCustomScript("select first location card")
		numberOfTimesCalled += 1
		
	elif numberOfTimesCalled == 1:
		GameState.HandleStrategyCardMenuForCustomScript("select second location card")
		numberOfTimesCalled += 1
		
	elif numberOfTimesCalled == 2:
		status = "Done"
		
	return status
	
func Effect():

	var values = GameState.GetStrategyPreparationValues()
	
	#take location cards from both indexes and swap where they were
	var cardOne = GameState.TakeLocationCardFromDockAtIndex(values[0])
	var cardTwo = GameState.TakeLocationCardFromDockAtIndex(values[1])
	GameState.GiveLocationCardToDockAtIndex(values[0], cardTwo)
	GameState.GiveLocationCardToDockAtIndex(values[1], cardOne)
	
	
	
	print("strategy card effect worked")
	
	
	return "Success"	#if the card effect could not be played/work, return "Fail"
	#this may happen if for instance the card effect moves a monster from one card to another
	#but neither passed location dock value has a monster docked in it
