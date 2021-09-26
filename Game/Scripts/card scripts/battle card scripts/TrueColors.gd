extends Node


var playerOwner = ""
var playerOwnerNewAttribute = ""
var otherNewAttribute = ""

func _ready():
	pass
	
#this cards effect is if your monster has lower health, swap the attributes
#of the monsters
	
	
func FilterMonsterAttack(attack):
	#rename this to FilterMonsterCardAttack()
	return attack


func FilterBattleCard(battleCardToFilter):
	#[attribute, true]
	#in case this battle card effects the ability of other battle cards to be played
	#what is the format of battle card's data?
	return battleCardToFilter
	
func FilterMonsterData(monsterData):
	
	if GameState.GetPlayerBattleTurn() == playerOwner:
		monsterData[0] = playerOwnerNewAttribute
	else:
		monsterData[0] = otherNewAttribute
		
	
	
	#[attribute, health]
	#if this battle card swapped attributes of the cards, it would do so here
	#or if it dealt damage maybe
	return monsterData
	
func Effect(filteredVersion):
	
	playerOwner = GameState.GetPlayerBattleTurn()
	var otherPlayer = ""
	
	if playerOwner == "PlayerOne":
		otherPlayer = "PlayerTwo"
	else:
		otherPlayer = "PlayerOne"
	
	
	#returns [attribute, health]
	var yourData = GameState.GetPlayerMonsterDataAtCurrentBattleIndex(playerOwner)
	var theirData = GameState.GetPlayerMonsterDataAtCurrentBattleIndex(otherPlayer)
	
	if yourData[1] < theirData[1]:
		#if your health is lower than theirs
		#set attributes to swap to when filtering monster data
		playerOwnerNewAttribute = theirData[0]
		otherNewAttribute = theirData[0]
	
	#no card/thing to filter, just do your effect by altering GameState
	#if this is being called, this is enabled, check the attribute
	#if this changed what kind of damage etc. is done by this card
	#although it probably won't
	
	#don't need to return filteredVersion, just to guide effect implementation
	
