extends Node


func _ready():
	pass
	
	
func Filter(attack):
	#rename this to FilterMonsterCardAttack()
	pass


func FilterBattleCard(battleCardToFilter):
	#[attribute, true]
	#in case this battle card effects the ability of other battle cards to be played
	#what is the format of battle card's data?
	pass
	
	
func Effect(filteredVersion):
	#no card/thing to filter, just do your effect by altering GameState
	#if this is being called, this is enabled, check the attribute
	#if this changed what kind of damage etc. is done by this card
	#although it probably won't
	print("battle card effect done")
