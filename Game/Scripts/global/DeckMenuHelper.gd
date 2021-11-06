extends Node

var locationCards = []
var monsterCards = []
var battleCards = []
var strategyCards = []

var browseMenuCardSelectedCardType = ""
var browseMenuCardSelectedCardFile = ""

var deckName = ""
var playersSelectingDecksForBattle = false

var currentlyShowingCardTypeBetweenEditDecksMenuAndBrowseCardsmenu = ""

func _ready():
	pass

func GetCurrentlyShowingCardType():
	return currentlyShowingCardTypeBetweenEditDecksMenuAndBrowseCardsmenu

func SetCurrentlyShowingCardType(newVal):
	currentlyShowingCardTypeBetweenEditDecksMenuAndBrowseCardsmenu = newVal

func GetPlayersSelectingDecksForBattle():
	return playersSelectingDecksForBattle

func SetPlayersSelectingDecksForBattle(newVal):
	playersSelectingDecksForBattle = newVal

func SetDeckName(newName):
	deckName = newName

func GetDeckName():
	return deckName


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


