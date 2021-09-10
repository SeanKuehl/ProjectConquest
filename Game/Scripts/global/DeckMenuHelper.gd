extends Node

var locationCards = []
var monsterCards = []
var battleCards = []
var strategyCards = []

var browseMenuCardSelectedCardType = ""
var browseMenuCardSelectedCardFile = ""

func _ready():
	pass
	
func SetCardSelected(cardType, cardFile):
	browseMenuCardSelectedCardType = cardType
	browseMenuCardSelectedCardFile = cardFile
	
func GetCardSelected():
	return [browseMenuCardSelectedCardType, browseMenuCardSelectedCardFile]
	
func SetDeck(locations, monsters, battles, strategys):
	locationCards = locations
	monsterCards = monsters
	battleCards = battles
	strategyCards = strategys
	
func GetDeck():
	return [locationCards, monsterCards, battleCards, strategyCards]
	
