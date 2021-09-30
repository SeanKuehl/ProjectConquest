extends Node

var playerToGiveHealthTo = ""

func _ready():
	pass
	
	
#this card's effect is the player currently losing the game gets +50 health

	
#dock is reference to a location card dock object
func ConnectSignalsFromLocationDock(dock):
	dock.connect("BattleStarted", self, "OnBattleStart")
	
	dock.connect("BattleEnded", self, "OnBattleEnd")	#I don't believe this signal is ever emmitted



func OnBattleStart():
	var playerWhoLandedLast = GameState.GetPlayerWhoLandedlast()
	
	#this card's effect is the player currently losing the game gets all
	#used battle cards back at the start of battle, nothing happens in a tie
	
	#get player with fewer victory points, 
	#then call func to move all of their "battle cards" to unused pile
	var playerOnePoints = GameState.GetPlayerVictoryPoints("PlayerOne")
	var playerTwoPoints = GameState.GetPlayerVictoryPoints("PlayerTwo")
	
	
	#what if player who needs them is taking their turn right now?
	#they won't see their cards until they are loaded again! Got to 
	#deal with that. If player is currently taking their turn,
	#load their cards again
	if playerOnePoints == playerTwoPoints:
		#it's a tie, do nothing
		
		pass
	elif playerOnePoints < playerTwoPoints:
		
		playerToGiveHealthTo = "PlayerOne"
		
	elif playerTwoPoints < playerOnePoints:
		
		playerToGiveHealthTo = "PlayerTwo"
	
	
	#by default, barring any effects, the player who landed last will go first in the battle
	GameState.SetPlayerBattleTurn(playerWhoLandedLast)
	#call another func to handle the battle stuff once this is done
	#other funcs in other place will handle the battle turns, this func is just for an effect and who decide who starts
	GameState.StartBattle()
	
	
	#cutom scripts can access GameState, great!
	
func FilterMonsterAttack(attack):
	#[1, "flaming Sting", 60, "Inferno", "there is a one in eight chance this attack does 100 damage", true, true]
	#if attack[2] == 40:
		#this filtering works!
		#attack[2] = 1000
		#attack[5] = false
		#attack[6] = false
	
		
	
		
		
	return attack
	
func FilterBattleCard(battleCardToFilter):
	#[attribute, true]
	
	return battleCardToFilter
	
func FilterMonsterData(monsterData):
	#[attribute, health]
	var ownerOfAttackingMonster = GameState.GetPlayerBattleTurn()
	
	if ownerOfAttackingMonster == playerToGiveHealthTo:
		monsterData[1] += 50
	#must return some version of the data, otherwise it's not filtering
	return monsterData
	
func OnBattleEnd():
	pass
