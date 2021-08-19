extends Node


func _ready():
	pass
	
func ConnectSignalsFromLocationDock(dock):
	dock.connect("BattleStarted", self, "OnBattleStart")
	#node.connect("battleCardUsed", self, "OnBattleCardUsed")	#this signal might not be needed
	dock.connect("BattleEnded", self, "OnBattleEnd")



func OnBattleStart():
	var playerWhoLandedLast = GameState.GetPlayerWhoLandedlast()
	
	#by default, barring any effects, the player who landed last will go first in the battle
	GameState.SetPlayerBattleTurn(playerWhoLandedLast)
	#call another func to handle the battle stuff once this is done
	#other funcs in other place will handle the battle turns, this func is just for an effect and who decide who starts
	GameState.StartBattle()
	
	
	#cutom scripts can access GameState, great!
	

	
func OnBattleEnd():
	print("battle ended")
