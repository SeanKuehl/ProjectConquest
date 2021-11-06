extends Node


var playerOwner = ""
var swapShouldHappen = false

func _ready():
	pass

#this cards effect is if you have less victory points then swap
#health


func FilterMonsterAttack(attack):
	#rename this to FilterMonsterCardAttack()
	return attack


func FilterBattleCard(battleCardToFilter):
	#[attribute, true]
	#in case this battle card effects the ability of other battle cards to be played
	#what is the format of battle card's data?
	return battleCardToFilter

func FilterMonsterData(monsterData):

	if swapShouldHappen:

		if GameState.GetPlayerBattleTurn() == "PlayerOne":
			#set your monsters health to theirs
			var otherPlayerHealth = GameState.GetPlayerMonsterDataAtCurrentBattleIndex("PlayerTwo")
			otherPlayerHealth = otherPlayerHealth[1]
			monsterData[1] = otherPlayerHealth
		else:
			#set their monster's health to yours
			var myHealth = GameState.GetPlayerMonsterDataAtCurrentBattleIndex("PlayerOne")
			myHealth = myHealth[1]
			monsterData[1] = myHealth


		#do the swap



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

	var yourPoints = GameState.GetPlayerVictoryPoints(playerOwner)
	var theirPoints = GameState.GetPlayerVictoryPoints(otherPlayer)

	if yourPoints < theirPoints:
		#prepare to do it, might not be exact same as attribute swap due to how their calculated
		swapShouldHappen = true

	#no card/thing to filter, just do your effect by altering GameState
	#if this is being called, this is enabled, check the attribute
	#if this changed what kind of damage etc. is done by this card
	#although it probably won't

	#don't need to return filteredVersion, just to guide effect implementation

