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
	
func Filter(attack):
	#[1, "flaming Sting", 60, "Inferno", "there is a one in eight chance this attack does 100 damage", true, true]
	if attack[2] == 40:
		#this filtering works!
		attack[2] = 1000
		attack[5] = false
		attack[6] = false
	return attack
	
func OnBattleEnd():
	print("battle ended")
