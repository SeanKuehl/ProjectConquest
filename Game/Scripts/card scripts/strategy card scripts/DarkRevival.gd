extends Node


var numberOfTimesCalled = 0
var status = "not done"

func _ready():
	pass

#this cards effect is move your last used monster to your unused pile
	
func Preparation():
	
	status = "Done"
		
	
		
		
	return status
	
func Effect():

	var values = GameState.GetStrategyPreparationValues()
	
	#current player
	var currentPlayer = GameState.GetPlayerBattleTurn()
	GameState.GetMonsterCardFromUsedPile(-1, currentPlayer)	#-1 is just a short form for last element in an array
	
	
	print("strategy card effect worked")
	
	
	return "Success"	#if the card effect could not be played/work, return "Fail"
	#this may happen if for instance the card effect moves a monster from one card to another
	#but neither passed location dock value has a monster docked in it
