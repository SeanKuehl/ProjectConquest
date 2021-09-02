# GdUnit generated TestSuite
class_name LocationCardDockTest
extends GdUnitTestSuite

# TestSuite generated from
const __source = 'res://Game/Scripts/Main/Docks/LocationCardDock.gd'

#test number_func being tested_name of test
#the input is too long/much in these tests to do it

#name must start with test_ for gdunit to find the test

#LocationCardPhysicsProcessCodeTestingStub tests
func test_t001_LocationCardPhysicsProcessCodeTestingStub_TestSetupWorking() -> void:
	# remove this line and complete your test
	#LocationCardPhysicsProcessCodeTestingStub(passedCardHoveredOverArea, turnState, battleState, currentTurn, passedStoredCard, passedMouseIsInTile)
	#[currentTurn, turnState, passedCardHoveredOverArea, passedStoredCard, battleState]
	#if it does nothing it returns [0]
	
	#arrange
	var locationDock = load("res://Game/Scripts/Main/Docks/LocationCardDock.gd")
	locationDock = locationDock.new()
	
	
	var turnState = "Setup"
	var battleState = ""
	var currentTurn = "PlayerOne"
	var passedStoredCard = 0	#if this is an actual card, it should reject the card hovered over area
	var passedMouseIsInTile = true
	var draggedOn = false
	var cardIsDocked = false
	var cardType = "Location"
	
	var expectedResult = ["PlayerTwo", "Setup", ""]
	var actualResult = ""
	
	#act
	actualResult = locationDock.LocationCardPhysicsProcessCodeTestingStub(turnState, battleState, currentTurn, passedStoredCard, passedMouseIsInTile, draggedOn, cardIsDocked, cardType)
	
	#assert
	assert_array(actualResult).is_equal(expectedResult)
	
	
	
func test_t002_LocationCardPhysicsProcessCodeTestingStub_TestSetupFailingAfterInitialIf() -> void:
	# remove this line and complete your test
	#LocationCardPhysicsProcessCodeTestingStub(passedCardHoveredOverArea, turnState, battleState, currentTurn, passedStoredCard, passedMouseIsInTile)
	#[currentTurn, turnState, passedCardHoveredOverArea, passedStoredCard, battleState]
	#if it does nothing it returns [0]
	
	#arrange
	var locationDock = load("res://Game/Scripts/Main/Docks/LocationCardDock.gd")
	locationDock = locationDock.new()
	
	
	var turnState = "Setup"
	var battleState = ""
	var currentTurn = "PlayerOne"
	var passedStoredCard = load("res://Game/Scripts/Main/Docks/LocationCardDock.gd")	#if this is an actual card, it should reject the card hovered over area
	var passedMouseIsInTile = false
	var draggedOn = true
	var cardIsDocked = true
	var cardType = "Battle"
	
	var expectedResult = [0]
	var actualResult = ""
	
	#act
	actualResult = locationDock.LocationCardPhysicsProcessCodeTestingStub(turnState, battleState, currentTurn, passedStoredCard, passedMouseIsInTile, draggedOn, cardIsDocked, cardType)
	
	#assert
	assert_array(actualResult).is_equal(expectedResult)
	
	
	
func test_t003_LocationCardPhysicsProcessCodeTestingStub_TestSetupFailingWithOnlyStoredCardWrong() -> void:
	# remove this line and complete your test
	#LocationCardPhysicsProcessCodeTestingStub(passedCardHoveredOverArea, turnState, battleState, currentTurn, passedStoredCard, passedMouseIsInTile)
	#[currentTurn, turnState, passedCardHoveredOverArea, passedStoredCard, battleState]
	#if it does nothing it returns [0]
	
	#arrange
	var locationDock = load("res://Game/Scripts/Main/Docks/LocationCardDock.gd")
	locationDock = locationDock.new()
	
	
	var turnState = "Setup"
	var battleState = ""
	var currentTurn = "PlayerOne"
	var passedStoredCard = load("res://Game/Scripts/Main/Docks/LocationCardDock.gd")	#if this is an actual card, it should reject the card hovered over area
	var passedMouseIsInTile = true
	var draggedOn = false
	var cardIsDocked = false
	var cardType = "Location"
	
	var expectedResult = [0]
	var actualResult = ""
	
	#act
	actualResult = locationDock.LocationCardPhysicsProcessCodeTestingStub(turnState, battleState, currentTurn, passedStoredCard, passedMouseIsInTile, draggedOn, cardIsDocked, cardType)
	
	#assert
	assert_array(actualResult).is_equal(expectedResult)
	
	
	
func test_t004_LocationCardPhysicsProcessCodeTestingStub_TestLocationWorking() -> void:
	# remove this line and complete your test
	#LocationCardPhysicsProcessCodeTestingStub(passedCardHoveredOverArea, turnState, battleState, currentTurn, passedStoredCard, passedMouseIsInTile)
	#[currentTurn, turnState, passedCardHoveredOverArea, passedStoredCard, battleState]
	#if it does nothing it returns [0]
	
	#arrange
	var locationDock = load("res://Game/Scripts/Main/Docks/LocationCardDock.gd")
	locationDock = locationDock.new()
	
	
	var turnState = "LocationCardPhase"
	var battleState = ""
	var currentTurn = "PlayerOne"
	var passedStoredCard = 0	#if this is an actual card, it should reject the card hovered over area
	var passedMouseIsInTile = true
	var draggedOn = false
	var cardIsDocked = false
	var cardType = "Location"
	
	var expectedResult = ["PlayerOne","MonsterCardPhase", ""]
	var actualResult = ""
	
	#act
	actualResult = locationDock.LocationCardPhysicsProcessCodeTestingStub(turnState, battleState, currentTurn, passedStoredCard, passedMouseIsInTile, draggedOn, cardIsDocked, cardType)
	
	#assert
	assert_array(actualResult).is_equal(expectedResult)
	
	
	
func test_t005_LocationCardPhysicsProcessCodeTestingStub_TestLocationFailingWithOnlyBattleState() -> void:
	# remove this line and complete your test
	#LocationCardPhysicsProcessCodeTestingStub(passedCardHoveredOverArea, turnState, battleState, currentTurn, passedStoredCard, passedMouseIsInTile)
	#[currentTurn, turnState, passedCardHoveredOverArea, passedStoredCard, battleState]
	#if it does nothing it returns [0]
	
	#arrange
	var locationDock = load("res://Game/Scripts/Main/Docks/LocationCardDock.gd")
	locationDock = locationDock.new()
	
	
	var turnState = "LocationCardPhase"
	var battleState = "MonsterCardPhase"
	var currentTurn = "PlayerOne"
	var passedStoredCard = 0	#if this is an actual card, it should reject the card hovered over area
	var passedMouseIsInTile = true
	var draggedOn = false
	var cardIsDocked = false
	var cardType = "Location"
	
	var expectedResult = [0]
	var actualResult = ""
	
	#act
	actualResult = locationDock.LocationCardPhysicsProcessCodeTestingStub(turnState, battleState, currentTurn, passedStoredCard, passedMouseIsInTile, draggedOn, cardIsDocked, cardType)
	
	#assert
	assert_array(actualResult).is_equal(expectedResult)
	
	
	
	
func test_t006_LocationCardPhysicsProcessCodeTestingStub_TestLocationFailingAfterInitialIf() -> void:
	# remove this line and complete your test
	#LocationCardPhysicsProcessCodeTestingStub(passedCardHoveredOverArea, turnState, battleState, currentTurn, passedStoredCard, passedMouseIsInTile)
	#[currentTurn, turnState, passedCardHoveredOverArea, passedStoredCard, battleState]
	#if it does nothing it returns [0]
	
	#arrange
	var locationDock = load("res://Game/Scripts/Main/Docks/LocationCardDock.gd")
	locationDock = locationDock.new()
	
	
	var turnState = "LocationCardPhase"
	var battleState = ""
	var currentTurn = "PlayerOne"
	var passedStoredCard = load("res://Game/Scripts/Main/Docks/LocationCardDock.gd")	#if this is an actual card, it should reject the card hovered over area
	var passedMouseIsInTile = false
	var draggedOn = true
	var cardIsDocked = true
	var cardType = "Battle"
	
	var expectedResult = [0]
	var actualResult = ""
	
	#act
	actualResult = locationDock.LocationCardPhysicsProcessCodeTestingStub(turnState, battleState, currentTurn, passedStoredCard, passedMouseIsInTile, draggedOn, cardIsDocked, cardType)
	
	#assert
	assert_array(actualResult).is_equal(expectedResult)
	
	
func test_t007_LocationCardPhysicsProcessCodeTestingStub_TestSetupWhenItIsPlayerTwoTurn() -> void:
	# remove this line and complete your test
	#LocationCardPhysicsProcessCodeTestingStub(passedCardHoveredOverArea, turnState, battleState, currentTurn, passedStoredCard, passedMouseIsInTile)
	#[currentTurn, turnState, passedCardHoveredOverArea, passedStoredCard, battleState]
	#if it does nothing it returns [0]
	
	#arrange
	var locationDock = load("res://Game/Scripts/Main/Docks/LocationCardDock.gd")
	locationDock = locationDock.new()
	
	
	var turnState = "Setup"
	var battleState = ""
	var currentTurn = "PlayerTwo"
	var passedStoredCard = 0	#if this is an actual card, it should reject the card hovered over area
	var passedMouseIsInTile = true
	var draggedOn = false
	var cardIsDocked = false
	var cardType = "Location"
	
	var expectedResult = ["PlayerOne", "LocationCardPhase", ""]
	var actualResult = ""
	
	#act
	actualResult = locationDock.LocationCardPhysicsProcessCodeTestingStub(turnState, battleState, currentTurn, passedStoredCard, passedMouseIsInTile, draggedOn, cardIsDocked, cardType)
	
	#assert
	assert_array(actualResult).is_equal(expectedResult)
	
	

func test_t008_MonsterCardPhaseHelperCodeTestingStub_TestPassingInitialIfButNothingElse() -> void:
	# remove this line and complete your test
	#MonsterCardPhaseHelperCodeTestingStub(draggedOn, cardIsDocked, cardType, inUsedPile, cardOwner, therIsCardOwnerMonster, turnState, battleStarted)
	#returns [turnState, battleStarted, thereIsCardOwnerMonster]
	#or [0] if it did nothing
	
	
	#arrange
	var locationDock = load("res://Game/Scripts/Main/Docks/LocationCardDock.gd")
	locationDock = locationDock.new()
	
	
	var draggedOn = false
	var cardIsDocked = false
	var cardType = "Monster"
	var inUsedPile = false
	var cardOwner = "PlayerOne"
	var thereIsCardOwnerMonster = true
	var turnState = "MonsterCardPhase"
	var battleStarted = false
	var thereIsOtherPlayerMonster = false	#this basically decides whether there's a battle or not
	
	var expectedResult = [0]
	var actualResult = ""
	
	#act
	actualResult = locationDock.MonsterCardPhaseHelperCodeTestingStub(draggedOn, cardIsDocked, cardType, inUsedPile, cardOwner, thereIsCardOwnerMonster, turnState, battleStarted, thereIsOtherPlayerMonster)
	
	#assert
	assert_array(actualResult).is_equal(expectedResult)
	
	
func test_t009_MonsterCardPhaseHelperCodeTestingStub_TestFailingInitialIf() -> void:
	# remove this line and complete your test
	#MonsterCardPhaseHelperCodeTestingStub(draggedOn, cardIsDocked, cardType, inUsedPile, cardOwner, therIsCardOwnerMonster, turnState, battleStarted)
	#returns [turnState, battleStarted, thereIsCardOwnerMonster]
	#or [0] if it did nothing
	
	
	#arrange
	var locationDock = load("res://Game/Scripts/Main/Docks/LocationCardDock.gd")
	locationDock = locationDock.new()
	
	
	var draggedOn = true
	var cardIsDocked = true
	var cardType = "Monster"
	var inUsedPile = false
	var cardOwner = "PlayerOne"
	var thereIsCardOwnerMonster = false
	var turnState = "MonsterCardPhase"
	var battleStarted = false
	var thereIsOtherPlayerMonster = false	#this basically decides whether there's a battle or not
	
	var expectedResult = [0]
	var actualResult = ""
	
	#act
	actualResult = locationDock.MonsterCardPhaseHelperCodeTestingStub(draggedOn, cardIsDocked, cardType, inUsedPile, cardOwner, thereIsCardOwnerMonster, turnState, battleStarted, thereIsOtherPlayerMonster)
	
	#assert
	assert_array(actualResult).is_equal(expectedResult)
	
	
	
func test_t010_MonsterCardPhaseHelperCodeTestingStub_TestPassingPlayerOne() -> void:
	# remove this line and complete your test
	#MonsterCardPhaseHelperCodeTestingStub(draggedOn, cardIsDocked, cardType, inUsedPile, cardOwner, therIsCardOwnerMonster, turnState, battleStarted)
	#returns [turnState, battleStarted, thereIsCardOwnerMonster]
	#or [0] if it did nothing
	
	
	#arrange
	var locationDock = load("res://Game/Scripts/Main/Docks/LocationCardDock.gd")
	locationDock = locationDock.new()
	
	
	var draggedOn = false
	var cardIsDocked = false
	var cardType = "Monster"
	var inUsedPile = false
	var cardOwner = "PlayerOne"
	var thereIsCardOwnerMonster = false
	var turnState = "MonsterCardPhase"
	var battleStarted = false
	var thereIsOtherPlayerMonster = false	#this basically decides whether there's a battle or not
	
	var expectedResult = ["StrategyCardPhase", false, true]
	var actualResult = ""
	
	#act
	actualResult = locationDock.MonsterCardPhaseHelperCodeTestingStub(draggedOn, cardIsDocked, cardType, inUsedPile, cardOwner, thereIsCardOwnerMonster, turnState, battleStarted, thereIsOtherPlayerMonster)
	
	#assert
	assert_array(actualResult).is_equal(expectedResult)
	
	
func test_t011_MonsterCardPhaseHelperCodeTestingStub_TestFailingPlayerOne() -> void:
	# remove this line and complete your test
	#MonsterCardPhaseHelperCodeTestingStub(draggedOn, cardIsDocked, cardType, inUsedPile, cardOwner, therIsCardOwnerMonster, turnState, battleStarted)
	#returns [turnState, battleStarted, thereIsCardOwnerMonster]
	#or [0] if it did nothing
	
	
	#arrange
	var locationDock = load("res://Game/Scripts/Main/Docks/LocationCardDock.gd")
	locationDock = locationDock.new()
	
	
	var draggedOn = false
	var cardIsDocked = false
	var cardType = "Monster"
	var inUsedPile = false
	var cardOwner = "PlayerOne"
	var thereIsCardOwnerMonster = true
	var turnState = "MonsterCardPhase"
	var battleStarted = false
	var thereIsOtherPlayerMonster = false	#this basically decides whether there's a battle or not
	
	var expectedResult = [0]
	var actualResult = ""
	
	#act
	actualResult = locationDock.MonsterCardPhaseHelperCodeTestingStub(draggedOn, cardIsDocked, cardType, inUsedPile, cardOwner, thereIsCardOwnerMonster, turnState, battleStarted, thereIsOtherPlayerMonster)
	
	#assert
	assert_array(actualResult).is_equal(expectedResult)
	
	
	
func test_t012_MonsterCardPhaseHelperCodeTestingStub_TestPlayerOneBattle() -> void:
	# remove this line and complete your test
	#MonsterCardPhaseHelperCodeTestingStub(draggedOn, cardIsDocked, cardType, inUsedPile, cardOwner, therIsCardOwnerMonster, turnState, battleStarted)
	#returns [turnState, battleStarted, thereIsCardOwnerMonster]
	#or [0] if it did nothing
	
	
	#arrange
	var locationDock = load("res://Game/Scripts/Main/Docks/LocationCardDock.gd")
	locationDock = locationDock.new()
	
	
	var draggedOn = false
	var cardIsDocked = false
	var cardType = "Monster"
	var inUsedPile = false
	var cardOwner = "PlayerOne"
	var thereIsCardOwnerMonster = false
	var turnState = "MonsterCardPhase"
	var battleStarted = false
	var thereIsOtherPlayerMonster = true	#this basically decides whether there's a battle or not
	
	var expectedResult = ["StrategyCardPhase", true, true]
	var actualResult = ""
	
	#act
	actualResult = locationDock.MonsterCardPhaseHelperCodeTestingStub(draggedOn, cardIsDocked, cardType, inUsedPile, cardOwner, thereIsCardOwnerMonster, turnState, battleStarted, thereIsOtherPlayerMonster)
	
	#assert
	assert_array(actualResult).is_equal(expectedResult)
	
	
func test_t013_MonsterCardPhaseHelperCodeTestingStub_TestPassingPlayerTwo() -> void:
	# remove this line and complete your test
	#MonsterCardPhaseHelperCodeTestingStub(draggedOn, cardIsDocked, cardType, inUsedPile, cardOwner, therIsCardOwnerMonster, turnState, battleStarted)
	#returns [turnState, battleStarted, thereIsCardOwnerMonster]
	#or [0] if it did nothing
	
	
	#arrange
	var locationDock = load("res://Game/Scripts/Main/Docks/LocationCardDock.gd")
	locationDock = locationDock.new()
	
	
	var draggedOn = false
	var cardIsDocked = false
	var cardType = "Monster"
	var inUsedPile = false
	var cardOwner = "PlayerTwo"
	var thereIsCardOwnerMonster = false
	var turnState = "MonsterCardPhase"
	var battleStarted = false
	var thereIsOtherPlayerMonster = false	#this basically decides whether there's a battle or not
	
	var expectedResult = ["StrategyCardPhase", false, true]
	var actualResult = ""
	
	#act
	actualResult = locationDock.MonsterCardPhaseHelperCodeTestingStub(draggedOn, cardIsDocked, cardType, inUsedPile, cardOwner, thereIsCardOwnerMonster, turnState, battleStarted, thereIsOtherPlayerMonster)
	
	#assert
	assert_array(actualResult).is_equal(expectedResult)
	
	
func test_t014_MonsterCardPhaseHelperCodeTestingStub_TestFailingPlayerTwo() -> void:
	# remove this line and complete your test
	#MonsterCardPhaseHelperCodeTestingStub(draggedOn, cardIsDocked, cardType, inUsedPile, cardOwner, therIsCardOwnerMonster, turnState, battleStarted)
	#returns [turnState, battleStarted, thereIsCardOwnerMonster]
	#or [0] if it did nothing
	
	
	#arrange
	var locationDock = load("res://Game/Scripts/Main/Docks/LocationCardDock.gd")
	locationDock = locationDock.new()
	
	
	var draggedOn = false
	var cardIsDocked = false
	var cardType = "Monster"
	var inUsedPile = false
	var cardOwner = "PlayerTwo"
	var thereIsCardOwnerMonster = true
	var turnState = "MonsterCardPhase"
	var battleStarted = false
	var thereIsOtherPlayerMonster = false	#this basically decides whether there's a battle or not
	
	var expectedResult = [0]
	var actualResult = ""
	
	#act
	actualResult = locationDock.MonsterCardPhaseHelperCodeTestingStub(draggedOn, cardIsDocked, cardType, inUsedPile, cardOwner, thereIsCardOwnerMonster, turnState, battleStarted, thereIsOtherPlayerMonster)
	
	#assert
	assert_array(actualResult).is_equal(expectedResult)
	
	
	
func test_t015_MonsterCardPhaseHelperCodeTestingStub_TestPlayerTwoBattle() -> void:
	# remove this line and complete your test
	#MonsterCardPhaseHelperCodeTestingStub(draggedOn, cardIsDocked, cardType, inUsedPile, cardOwner, therIsCardOwnerMonster, turnState, battleStarted)
	#returns [turnState, battleStarted, thereIsCardOwnerMonster]
	#or [0] if it did nothing
	
	
	#arrange
	var locationDock = load("res://Game/Scripts/Main/Docks/LocationCardDock.gd")
	locationDock = locationDock.new()
	
	
	var draggedOn = false
	var cardIsDocked = false
	var cardType = "Monster"
	var inUsedPile = false
	var cardOwner = "PlayerTwo"
	var thereIsCardOwnerMonster = false
	var turnState = "MonsterCardPhase"
	var battleStarted = false
	var thereIsOtherPlayerMonster = true	#this basically decides whether there's a battle or not
	
	var expectedResult = ["StrategyCardPhase", true, true]
	var actualResult = ""
	
	#act
	actualResult = locationDock.MonsterCardPhaseHelperCodeTestingStub(draggedOn, cardIsDocked, cardType, inUsedPile, cardOwner, thereIsCardOwnerMonster, turnState, battleStarted, thereIsOtherPlayerMonster)
	
	#assert
	assert_array(actualResult).is_equal(expectedResult)



func test_t016_BattleCardPhysicsProcessCodeTestingStub_TestFailingInitialIf() -> void:
	# remove this line and complete your test
	#BattleCardPhysicsProcessCodeTestingStub(battleState, draggedOn, isDocked, cardType, thereIsBattle, battleCardWasAllowedByFilter)
	#returns [turnState, battleStarted, thereIsCardOwnerMonster]
	#or [0] if it did nothing
	
	
	#arrange
	var locationDock = load("res://Game/Scripts/Main/Docks/LocationCardDock.gd")
	locationDock = locationDock.new()
	
	var battleState = ""
	var draggedOn = false
	var isDocked = false
	var cardType = "Battle"
	var thereIsBattle = false
	var battleCardWasAllowedByFilter = false
	
	
	
	
	var expectedResult = [0]
	var actualResult = ""
	
	#act
	actualResult = locationDock.BattleCardPhysicsProcessCodeTestingStub(battleState, draggedOn, isDocked, cardType, thereIsBattle, battleCardWasAllowedByFilter)
	
	#assert
	assert_array(actualResult).is_equal(expectedResult)



func test_t017_BattleCardPhysicsProcessCodeTestingStub_TestPassingInitialIfButFailingSecond() -> void:
	# remove this line and complete your test
	#BattleCardPhysicsProcessCodeTestingStub(battleState, draggedOn, isDocked, cardType, thereIsBattle, battleCardWasAllowedByFilter)
	#returns [turnState, battleStarted, thereIsCardOwnerMonster]
	#or [0] if it did nothing
	
	
	#arrange
	var locationDock = load("res://Game/Scripts/Main/Docks/LocationCardDock.gd")
	locationDock = locationDock.new()
	
	var battleState = "BattleCardPhase"
	var draggedOn = true
	var isDocked = true
	var cardType = "Strategy"
	var thereIsBattle = false
	var battleCardWasAllowedByFilter = false
	
	
	
	
	var expectedResult = [0]
	var actualResult = ""
	
	#act
	actualResult = locationDock.BattleCardPhysicsProcessCodeTestingStub(battleState, draggedOn, isDocked, cardType, thereIsBattle, battleCardWasAllowedByFilter)
	
	#assert
	assert_array(actualResult).is_equal(expectedResult)
	
	
	
	
func test_t018_BattleCardPhysicsProcessCodeTestingStub_TestBattleCardAllowed() -> void:
	# remove this line and complete your test
	#BattleCardPhysicsProcessCodeTestingStub(battleState, draggedOn, isDocked, cardType, thereIsBattle, battleCardWasAllowedByFilter)
	#returns [turnState, battleStarted, thereIsCardOwnerMonster]
	#or [0] if it did nothing
	
	
	#arrange
	var locationDock = load("res://Game/Scripts/Main/Docks/LocationCardDock.gd")
	locationDock = locationDock.new()
	
	var battleState = "BattleCardPhase"
	var draggedOn = false
	var isDocked = false
	var cardType = "Battle"
	var thereIsBattle = true
	var battleCardWasAllowedByFilter = true
	
	
	
	
	var expectedResult = [battleCardWasAllowedByFilter, "allowed"]
	var actualResult = ""
	
	#act
	actualResult = locationDock.BattleCardPhysicsProcessCodeTestingStub(battleState, draggedOn, isDocked, cardType, thereIsBattle, battleCardWasAllowedByFilter)
	
	#assert
	assert_array(actualResult).is_equal(expectedResult)




func test_t019_BattleCardPhysicsProcessCodeTestingStub_TestBattleCardDisallowed() -> void:
	# remove this line and complete your test
	#BattleCardPhysicsProcessCodeTestingStub(battleState, draggedOn, isDocked, cardType, thereIsBattle, battleCardWasAllowedByFilter)
	#returns [turnState, battleStarted, thereIsCardOwnerMonster]
	#or [0] if it did nothing
	
	
	#arrange
	var locationDock = load("res://Game/Scripts/Main/Docks/LocationCardDock.gd")
	locationDock = locationDock.new()
	
	var battleState = "BattleCardPhase"
	var draggedOn = false
	var isDocked = false
	var cardType = "Battle"
	var thereIsBattle = true
	var battleCardWasAllowedByFilter = false
	
	
	
	
	var expectedResult = [battleCardWasAllowedByFilter, "disallowed"]
	var actualResult = ""
	
	#act
	actualResult = locationDock.BattleCardPhysicsProcessCodeTestingStub(battleState, draggedOn, isDocked, cardType, thereIsBattle, battleCardWasAllowedByFilter)
	
	#assert
	assert_array(actualResult).is_equal(expectedResult)



func test_t020_StrategyCardActivateEffectHelperCodeTestingStub_TestSucceed() -> void:
	# remove this line and complete your test
	#StrategyCardActivateEffectHelperCodeTestingStub(effectOutcome)
	#returns [effectOutcome, "pass"], [effectOutcome, "fail"]
	#or ["typo"] 
	
	
	#arrange
	var locationDock = load("res://Game/Scripts/Main/Docks/LocationCardDock.gd")
	locationDock = locationDock.new()
	
	
	
	var effectOutcome = "Success"
	
	
	var expectedResult = ["Success", "pass"]
	var actualResult = ""
	
	#act
	actualResult = locationDock.StrategyCardActivateEffectHelperCodeTestingStub(effectOutcome)
	
	#assert
	assert_array(actualResult).is_equal(expectedResult)




func test_t021_StrategyCardActivateEffectHelperCodeTestingStub_TestFail() -> void:
	# remove this line and complete your test
	#StrategyCardActivateEffectHelperCodeTestingStub(effectOutcome)
	#returns [effectOutcome, "pass"], [effectOutcome, "fail"]
	#or ["typo"] 
	
	
	#arrange
	var locationDock = load("res://Game/Scripts/Main/Docks/LocationCardDock.gd")
	locationDock = locationDock.new()
	
	
	
	var effectOutcome = "Fail"
	
	
	var expectedResult = ["Fail", "fail"]
	var actualResult = ""
	
	#act
	actualResult = locationDock.StrategyCardActivateEffectHelperCodeTestingStub(effectOutcome)
	
	#assert
	assert_array(actualResult).is_equal(expectedResult)
	
	
	
	
	
func test_t022_StrategyCardActivateEffectHelperCodeTestingStub_TestSuccessTypo() -> void:
	# remove this line and complete your test
	#StrategyCardActivateEffectHelperCodeTestingStub(effectOutcome)
	#returns [effectOutcome, "pass"], [effectOutcome, "fail"]
	#or ["typo"] 
	
	
	#arrange
	var locationDock = load("res://Game/Scripts/Main/Docks/LocationCardDock.gd")
	locationDock = locationDock.new()
	
	
	
	var effectOutcome = "success"
	
	
	var expectedResult = ["typo"]
	var actualResult = ""
	
	#act
	actualResult = locationDock.StrategyCardActivateEffectHelperCodeTestingStub(effectOutcome)
	
	#assert
	assert_array(actualResult).is_equal(expectedResult)
	
	
	
	
func test_t023_StrategyCardActivateEffectHelperCodeTestingStub_TestFailTypo() -> void:
	# remove this line and complete your test
	#StrategyCardActivateEffectHelperCodeTestingStub(effectOutcome)
	#returns [effectOutcome, "pass"], [effectOutcome, "fail"]
	#or ["typo"] 
	
	
	#arrange
	var locationDock = load("res://Game/Scripts/Main/Docks/LocationCardDock.gd")
	locationDock = locationDock.new()
	
	
	
	var effectOutcome = "fail"
	
	
	var expectedResult = ["typo"]
	var actualResult = ""
	
	#act
	actualResult = locationDock.StrategyCardActivateEffectHelperCodeTestingStub(effectOutcome)
	
	#assert
	assert_array(actualResult).is_equal(expectedResult)
