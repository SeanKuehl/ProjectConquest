extends Node


func _ready():
	pass

#this card's effect is that the monster named "Tiko"'s attacks do +20 damage


#dock is reference to a location card dock object
func ConnectSignalsFromLocationDock(dock):
	dock.connect("BattleStarted", self, "OnBattleStart")

	dock.connect("BattleEnded", self, "OnBattleEnd")	#I don't believe this signal is ever emmitted



func OnBattleStart():
	var playerWhoLandedLast = GameState.GetPlayerWhoLandedlast()

	#by default, barring any effects, the player who landed last will go first in the battle
	GameState.SetPlayerBattleTurn(playerWhoLandedLast)
	#call another func to handle the battle stuff once this is done
	#other funcs in other place will handle the battle turns, this func is just for an effect and who decide who starts
	GameState.StartBattle()


	#cutom scripts can access GameState, great!

func FilterMonsterAttack(attack):
	#[1, "flaming Sting", 60, "Inferno", "there is a one in eight chance this attack does 100 damage", true, true]
	#this card's effect is that the monster named "Tiko"'s attacks do +20 damage
	if GameState.GetCurrentTurnMonsterNameAtCurrentBattleIndex() == "Tiko":
		attack[2] += 20

	return attack

func FilterBattleCard(battleCardToFilter):
	#[attribute, true]

	return battleCardToFilter

func FilterMonsterData(monsterData):
	#must return some version of the data, otherwise it's not filtering
	return monsterData

func OnBattleEnd():
	pass
