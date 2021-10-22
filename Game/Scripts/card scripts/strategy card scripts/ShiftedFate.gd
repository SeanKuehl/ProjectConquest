extends Node


var numberOfTimesCalled = 0
var status = "not done"

func _ready():
	pass

#this cards effect is move an oppoents docked monster card to another card of your choosing
	
func Preparation():
	if numberOfTimesCalled == 0:
		GameState.HandleStrategyCardMenuForCustomScript("select card to take opponent's monster from")
		numberOfTimesCalled += 1
		
	elif numberOfTimesCalled == 1:
		GameState.HandleStrategyCardMenuForCustomScript("select card to take opponent's monster to")
		numberOfTimesCalled += 1
		
	elif numberOfTimesCalled == 2:
		status = "Done"
		
	return status
	
func Effect():

	var values = GameState.GetStrategyPreparationValues()
	var currentPlayer = GameState.GetPlayerBattleTurn()
	
	#we want to take the other player's monster
	var playerToMoveMonsterOf = ""
	
	if currentPlayer == "PlayerOne":
		playerToMoveMonsterOf = "PlayerTwo"
	else:
		playerToMoveMonsterOf = "PlayerOne"
	
	#take card from first location card 
	var monsterToMove = GameState.TakeMonsterFromDockAtIndex(values[0]-1, playerToMoveMonsterOf)	#the -1 is here because the returned index is 1-9 not 0-8 which is how they are accessed in the list
	
	
	GameState.GiveMonsterToDockAtIndex(values[1]-1, playerToMoveMonsterOf, monsterToMove)	#the -1 is here because the returned index is 1-9 not 0-8 which is how they are accessed in the list
	
	
	return "Success"	#if the card effect could not be played/work, return "Fail"
	#this may happen if for instance the card effect moves a monster from one card to another
	#but neither passed location dock value has a monster docked in it



