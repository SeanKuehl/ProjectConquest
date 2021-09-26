extends Node


var playerOwner = ""
var numberOfUsedStrategyCards = -100	#if this val is used, it will be obviouse



func _ready():
	pass
	
	
	
	
#this cards effect is your monster gains 20 health for every strategy card in
#your opponents used pile
	
func FilterMonsterAttack(attack):
	#rename this to FilterMonsterCardAttack()
	return attack


func FilterBattleCard(battleCardToFilter):
	#[attribute, true]
	#in case this battle card effects the ability of other battle cards to be played
	#what is the format of battle card's data?
	return battleCardToFilter
	
func FilterMonsterData(monsterData):
	
	var healthPerCardAccordingToEffect = 20
	
	if playerOwner == GameState.GetPlayerBattleTurn():
		#if it's your turn, your monster
		monsterData[1] += numberOfUsedStrategyCards * healthPerCardAccordingToEffect
	
	#[attribute, health]
	#if this battle card swapped attributes of the cards, it would do so here
	#or if it dealt damage maybe
	return monsterData
	
func Effect(filteredVersion):
	
	playerOwner = GameState.GetPlayerBattleTurn()
	
	if playerOwner == "PlayerOne":
		#used cards come as [location, monster, battle, strat]	#each item is also a list
		var usedCards = GameState.GetPlayerTwoUsedCards()
		var usedStrategyCards = usedCards[3]
		numberOfUsedStrategyCards = len(usedStrategyCards)
	else:
		#used cards come as [location, monster, battle, strat]	#each item is also a list
		var usedCards = GameState.GetPlayerOneUsedCards()
		var usedStrategyCards = usedCards[3]
		numberOfUsedStrategyCards = len(usedStrategyCards)
	
	
	#no card/thing to filter, just do your effect by altering GameState
	#if this is being called, this is enabled, check the attribute
	#if this changed what kind of damage etc. is done by this card
	#although it probably won't
	
	#don't need to return filteredVersion, just to guide effect implementation
	
