extends Node


var numberOfTimesCalled = 0
var status = "not done"

func _ready():
	pass

#maybe setup a signal or something for when the user makes their selection

func Preparation():
	if numberOfTimesCalled == 0:
		GameState.HandleStrategyCardMenuForCustomScript("one")
		numberOfTimesCalled += 1

	elif numberOfTimesCalled == 1:
		GameState.HandleStrategyCardMenuForCustomScript("two")
		numberOfTimesCalled += 1

	elif numberOfTimesCalled == 2:
		status = "Done"

	return status

func Effect():

	var values = GameState.GetStrategyPreparationValues()

	print("strategy card effect worked")


	return "Success"	#if the card effect could not be played/work, return "Fail"
	#this may happen if for instance the card effect moves a monster from one card to another
	#but neither passed location dock value has a monster docked in it
