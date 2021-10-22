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
	var cardOne = GameState.TakeLocationCardFromDockAtIndex(values[0]-1)	#the -1 is here because the returned index is 1-9 not 0-8 which is how they are accessed in the list
	var cardTwo = GameState.TakeLocationCardFromDockAtIndex(values[1]-1)	#the -1 is here because the returned index is 1-9 not 0-8 which is how they are accessed in the list
	GameState.GiveLocationCardToDockAtIndex(values[0]-1, cardTwo)	#the -1 is here because the returned index is 1-9 not 0-8 which is how they are accessed in the list
	GameState.GiveLocationCardToDockAtIndex(values[1]-1, cardOne)	#the -1 is here because the returned index is 1-9 not 0-8 which is how they are accessed in the list
	
	
	
	print("strategy card effect worked")
	
	
	return "Success"	#if the card effect could not be played/work, return "Fail"
	#this may happen if for instance the card effect moves a monster from one card to another
	#but neither passed location dock value has a monster docked in it
