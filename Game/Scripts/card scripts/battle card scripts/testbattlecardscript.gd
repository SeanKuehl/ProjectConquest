extends Node


func _ready():
	pass
	
	
func FilterMonsterAttack(attack):
	#rename this to FilterMonsterCardAttack()
	return attack


func FilterBattleCard(battleCardToFilter):
	#[attribute, true]
	#in case this battle card effects the ability of other battle cards to be played
	#what is the format of battle card's data?
	return battleCardToFilter
	
func FilterMonsterData(monsterData):
	#if this battle card swapped attributes of the cards, it would do so here
	#or if it dealt damage maybe
	return monsterData
	
func Effect(filteredVersion):
	#no card/thing to filter, just do your effect by altering GameState
	#if this is being called, this is enabled, check the attribute
	#if this changed what kind of damage etc. is done by this card
	#although it probably won't
	
	#don't need to return filteredVersion, just to guide effect implementation
	print("battle card effect done")
