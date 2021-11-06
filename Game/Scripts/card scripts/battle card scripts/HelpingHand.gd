extends Node


func _ready():
	pass

var playerOwner = ""
var attribute = "Divine"

#this cards effect is to give the monster with the same attribute as this card +100 health
#the monster belongs to the owner of this card

func FilterMonsterAttack(attack):
	#rename this to FilterMonsterCardAttack()
	return attack


func FilterBattleCard(battleCardToFilter):
	#[attribute, true]
	#in case this battle card effects the ability of other battle cards to be played
	#what is the format of battle card's data?
	return battleCardToFilter

func FilterMonsterData(monsterData):
	#[attribute, health]

	if GameState.GetPlayerBattleTurn() == playerOwner:
		if monsterData[0] == attribute:
			monsterData[1] += 100

	#if this battle card swapped attributes of the cards, it would do so here
	#or if it dealt damage maybe
	return monsterData

func Effect(filteredVersion):
	#get playerOwner
	playerOwner = GameState.GetPlayerBattleTurn()




	#no card/thing to filter, just do your effect by altering GameState
	#if this is being called, this is enabled, check the attribute
	#if this changed what kind of damage etc. is done by this card
	#although it probably won't

	#don't need to return filteredVersion, just to guide effect implementation

