extends KinematicBody2D

#when you hold click, show the canvas layer popup for as long as you are
#holding down click

#use the signals to tell the canvas layer when to popup and what information it needs

#this one node will represent all kinds of cards,
#will need different kinds of singals to display the different kinds

var colorSubDict = {"RED": "res://Game/Assets/Images/Experimental/Red.png",
"BLUE": "res://Game/Assets/Images/Experimental/Blue.png",
"BLACK": "res://Game/Assets/Images/Experimental/Black.png",
"YELLOW": "res://Game/Assets/Images/Experimental/Yellow.png",
"GREY": "res://Game/Assets/Images/Experimental/Grey.png",
"GREEN": "res://Game/Assets/Images/Experimental/Green.png"}

var mouseInTile = false
var popupShowing = false

var cardName = ""
var cardDescription = ""	#could also be effect
var cardPicture = ""
var attribute = ""
var health = ""
var attacks = ""

var cardType = ""	#decided by what type of card it initializes

var file = ""	#used to pass back to menu to save this card to deck

var menuState = ""

#will need signals for communicating with the popup thing
signal ShowStrategyOrLocationCard(cardName, cardDescription, cardPicture)
signal ShowBattleCard(cardName, cardDescription, cardPicture, attribute)
signal ShowMonsterCard(cardName, cardDescription, cardPicture, attribute, health)
signal HideInfoDisplay()


func _ready():
	#there was an issue where if you clicked on a card spot in the edit decks menu
	#that same click could select a card on this menu without you meaning it
	#thus I added a timer so that that click cannot be the same one that selects
	#a card
	$CancelOutPreviouseMenuClickTimer.start()
	


func SetMenuState(newState):
	menuState = newState

func initAsLocationCard(passedFile):
	cardType = "Location"
	file = passedFile
	var content = ReadLinesFromFile(passedFile)

	$BaseBackground/CardBack.texture = load(colorSubDict["BLACK"])
	$ColorBackground/Red.texture = load(colorSubDict["RED"])
	$PictureBackground/Yellow.texture = load(colorSubDict["BLUE"])
	
	cardName = content[0]	
	
	$Name.text = cardName
	
	#this will change because there could actually be an effect
	cardDescription = content[2]
	
	
	
	
	#load the image
	cardPicture = content[1]
	var image = load("res://Game/Assets/Images/Experimental/"+cardPicture)
	cardPicture = image	#this is for later when it's passed to the cardDisplay
	
	$Picture/Blue.texture = image
	#actual pic is texture property
	#it's just highlighting, which may be why it doesn't work on black
	
	var numberOfEffectLines = int(content[3])
	
	if numberOfEffectLines == 0:
		pass
		#there is no effect, show description
		
		
		#no need to filter description with the max chars code like effect
		#because description is only one line
		
		#descriptionOrEffectLabel.text = cardDescription
		#customScript = content[4]
	else:
		
		var effect = ""
		var effectLinesStartIndex = 4
		var customScriptIndex = 4
		for x in range(effectLinesStartIndex,effectLinesStartIndex+numberOfEffectLines):
			effect += content[x]
			customScriptIndex += 1
			
		#customScript = content[customScriptIndex]
		cardDescription = effect	#this is required because the signal to the display sends cardDescription and not effect
		#cardEffect = effect
		
		#max amount of chars in effect/description before overflow is 225(len of the string)
		#this only applied visually on the card, it can be as long as it wants in card display because it can scroll
		var maxAmountOfCharsInEffect = 225
		if len(effect) > maxAmountOfCharsInEffect:
			effect.erase(maxAmountOfCharsInEffect, len(effect)-maxAmountOfCharsInEffect)	#from the max chars points, erase as many chars as needed to cut the string down to max size
			effect[-3] = '.'
			effect[-2] = '.'
			effect[-1] = '.'	#make the last three characters '...'
			
		
		
		#descriptionOrEffectLabel.text = effect
		
		#customScript = load(customScriptDirectory+customScript)
		#customScript = customScript.new()
		#customScript.ConnectSignalsFromRoot(parent)
	
	


func initAsStrategyCard(passedFile):
	cardType = "Strategy"
	file = passedFile
	var content = ReadLinesFromFile(passedFile)

	$BaseBackground/CardBack.texture = load(colorSubDict["YELLOW"])
	$ColorBackground/Red.texture = load(colorSubDict["BLACK"])
	$PictureBackground/Yellow.texture = load(colorSubDict["YELLOW"])
	
	cardName = content[0]	
	
	$Name.text = cardName
	
	#this will change because there could actually be an effect
	cardDescription = content[2]
	
	
	
	
	#load the image
	cardPicture = content[1]
	var image = load("res://Game/Assets/Images/Experimental/"+cardPicture)
	cardPicture = image	#this is for later when it's passed to the cardDisplay
	
	$Picture/Blue.texture = image
	#actual pic is texture property
	#it's just highlighting, which may be why it doesn't work on black
	
	var numberOfEffectLines = int(content[3])
	
	if numberOfEffectLines == 0:
		pass
		#there is no effect, show description
		
		#description is only one line, so it doesn't need to be checked by the 
		#max amount of chars code
		
		#descriptionOrEffectLabel.text = cardDescription
		#customScript = content[4]
	else:
		
		var effect = ""
		var effectLinesStartIndex = 4
		var customScriptIndex = 4
		for x in range(effectLinesStartIndex,effectLinesStartIndex+numberOfEffectLines):
			effect += content[x]
			customScriptIndex += 1
			
		#customScript = content[customScriptIndex]
		cardDescription = effect	#this is required because the signal to the display sends cardDescription and not effect
		#cardEffect = effect
		
		#max amount of chars in effect/description before overflow is 225(len of the string)
		#this only applied visually on the card, it can be as long as it wants in card display because it can scroll
		var maxAmountOfCharsInEffect = 225
		if len(effect) > maxAmountOfCharsInEffect:
			effect.erase(maxAmountOfCharsInEffect, len(effect)-maxAmountOfCharsInEffect)	#from the max chars points, erase as many chars as needed to cut the string down to max size
			effect[-3] = '.'
			effect[-2] = '.'
			effect[-1] = '.'	#make the last three characters '...'
		
		
		#descriptionOrEffectLabel.text = effect
		
		#customScript = load(customScriptDirectory+customScript)
		#customScript = customScript.new()
		
	
	

func initAsBattleCard(passedFile):
	cardType = "Battle"
	file = passedFile
	var content = ReadLinesFromFile(passedFile)

	$BaseBackground/CardBack.texture = load(colorSubDict["BLACK"])
	$ColorBackground/Red.texture = load(colorSubDict["BLUE"])
	$PictureBackground/Yellow.texture = load(colorSubDict["RED"])
	
	cardName = content[0]	
	
	$Name.text = cardName
	
	#this will change because there could actually be an effect
	cardDescription = content[2]
	
	
	
	
	#load the image
	cardPicture = content[1]
	var image = load("res://Game/Assets/Images/Experimental/"+cardPicture)
	cardPicture = image	#this is for later when it's passed to the cardDisplay
	
	$Picture/Blue.texture = image
	#actual pic is texture property
	#it's just highlighting, which may be why it doesn't work on black
	
	var numberOfEffectLines = int(content[3])
	
	if numberOfEffectLines == 0:
		#there is no effect, show description
		
		
		var tempDescription = cardDescription
		
		#max amount of chars in effect/description before overflow is 225(len of the string)
		#this only applied visually on the card, it can be as long as it wants in card display because it can scroll
		var maxAmountOfCharsInDesc = 225
		if len(tempDescription) > maxAmountOfCharsInDesc:
			tempDescription.erase(maxAmountOfCharsInDesc, len(tempDescription)-maxAmountOfCharsInDesc)	#from the max chars points, erase as many chars as needed to cut the string down to max size
			tempDescription[-3] = '.'
			tempDescription[-2] = '.'
			tempDescription[-1] = '.'	#make the last three characters '...'
		
		
		
		
		#descriptionOrEffectLabel.text = tempDescription
		#customScript = content[4]
	else:
		
		var effect = ""
		var effectLinesStartIndex = 4
		var customScriptIndex = 4
		for x in range(effectLinesStartIndex,effectLinesStartIndex+numberOfEffectLines):
			effect += content[x]
			customScriptIndex += 1
		
		#customScript = content[customScriptIndex]
		
		attribute = content[customScriptIndex+1]
		
		
		cardDescription = effect	#this is required because the signal to the display sends cardDescription and not effect
		#cardEffect = effect
		
		#max amount of chars in effect/description before overflow is 225(len of the string)
		#this only applied visually on the card, it can be as long as it wants in card display because it can scroll
		var maxAmountOfCharsInEffect = 225
		if len(effect) > maxAmountOfCharsInEffect:
			effect.erase(maxAmountOfCharsInEffect, len(effect)-maxAmountOfCharsInEffect)	#from the max chars points, erase as many chars as needed to cut the string down to max size
			effect[-3] = '.'
			effect[-2] = '.'
			effect[-1] = '.'	#make the last three characters '...'
			
		
		#descriptionOrEffectLabel.text = effect
		
		#customScript = load(customScriptDirectory+customScript)
		#customScript = customScript.new()
		#customScript.ConnectSignalsFromRoot(parent)
	
	
	

func initAsMonsterCard(passedFile):
	
	cardType = "Monster"
	file = passedFile
	var content = ReadLinesFromFile(passedFile)

	$BaseBackground/CardBack.texture = load(colorSubDict["BLACK"])
	$ColorBackground/Red.texture = load(colorSubDict["GREEN"])
	$PictureBackground/Yellow.texture = load(colorSubDict["BLACK"])
	
	
	cardName = content[0]	
	
	$Name.text = cardName
	
	#this will change because there could actually be an effect
	cardDescription = content[2]
	
	
	
	#load the image
	cardPicture = content[1]
	var image = load("res://Game/Assets/Images/Experimental/"+cardPicture)
	cardPicture = image	#this is for later when it's passed to the cardDisplay
	
	$Picture/Blue.texture = image
	#actual pic is texture property
	#it's just highlighting, which may be why it doesn't work on black
	
	attribute = content[3]
	#attributeLabel.text = attribute
	
	health = content[4]
	#healthLabel.text = health+"hp"
	
	var numberOfAttacks = int(content[5])
	
	var textFileIndex = 6
	attacks = []
	
	while numberOfAttacks > 0:
		#each attack is a number followed by that many lines of text
		
		var linesOfTextOfAttack = int(content[textFileIndex])
		
		var thisAttack = ""
		
		for x in range(textFileIndex+1, textFileIndex+linesOfTextOfAttack+1):
			#+1 because max is exclusive
			thisAttack += content[x]
			
		
		textFileIndex += linesOfTextOfAttack+1	#skip to the next line after the attack
		attacks.append(thisAttack)
		thisAttack = ""
		numberOfAttacks -= 1
		
	#sound = content[textFileIndex]
	#$SoundPlayer.stream = load("res://Game/Assets/Sounds/Monster sounds/"+sound)
	#$SoundPlayer.play()
	#the sound file must be set without loop under the import menu
	#and reimported
	#$SoundPlayer.stop()
	
	#get the three frames of animation
	var numberOfAnimationFrames = 3
	for x in range(textFileIndex+1, textFileIndex+numberOfAnimationFrames+1):
		#max is exclusive
		#animation.append(content[x])
		pass
		
	
	textFileIndex+= numberOfAnimationFrames + 1
	
	#customScript = load("res://Game/Scripts/card scripts/monster card scripts/"+content[textFileIndex])
	#customScript = customScript.new()
	
	#set background colors
	#baseBackground.texture = baseBackgroundColor
	#colorBackground.texture = colorBackgroundColor
	#pictureBackground.texture = pictureBackgroundColor
	#descriptionOrEffectBackground.texture = descriptionOrEffectBackgroundColor

	#a monster card will always have attacks, so overwrite description
	var attacksAsTextToDisplay = ""
	for x in attacks:
		attacksAsTextToDisplay += x
	cardDescription = attacksAsTextToDisplay
	
	
	#max amount of chars in effect/description before overflow is 225(len of the string)
	#this only applied visually on the card, it can be as long as it wants in card display because it can scroll
	var maxAmountOfCharsInAttacks = 225
	if len(attacksAsTextToDisplay) > maxAmountOfCharsInAttacks:
		attacksAsTextToDisplay.erase(maxAmountOfCharsInAttacks, len(attacksAsTextToDisplay)-maxAmountOfCharsInAttacks)	#from the max chars points, erase as many chars as needed to cut the string down to max size
		attacksAsTextToDisplay[-3] = '.'
		attacksAsTextToDisplay[-2] = '.'
		attacksAsTextToDisplay[-1] = '.'	#make the last three characters '...'
	
	#descriptionOrEffectLabel.text = attacksAsTextToDisplay
	
#this func is used to show a blank in the edit decks menu
func initAsBlank():
	$BaseBackground/CardBack.texture = load(colorSubDict["GREY"])
	$ColorBackground/Red.texture = load(colorSubDict["GREY"])
	$PictureBackground/Yellow.texture = load(colorSubDict["GREY"])
	
	$Name.text = ""
	$Picture/Blue.texture = load(colorSubDict["GREY"])
	

func get_input():
	#use states to manage how it acts on a givin menu
	
	#use right click to see card info, use left click to save card to deck
	if menuState == "EditMenus" and $CancelOutPreviouseMenuClickTimer.is_stopped():
		#if they right click, it removes a card from the list!
		if Input.is_action_pressed("CLICK") and mouseInTile:
			#call parent and get parent to switch to browse cards menu
			get_parent().CallBrowseCardsMenu()
			
		if Input.is_action_pressed("RIGHT_CLICK") and mouseInTile:
			get_parent().RemoveCardFromDeck()
		
		
	elif menuState == "BrowseMenu" and $CancelOutPreviouseMenuClickTimer.is_stopped():
		
		if Input.is_action_pressed("CLICK") and mouseInTile:
			get_parent().SaveCardToDeck(cardType, file)
		
		if Input.is_action_pressed("RIGHT_CLICK"):
			if popupShowing:
				emit_signal("HideInfoDisplay")
				popupShowing = false
		
		
		if Input.is_action_pressed("RIGHT_CLICK") and mouseInTile:
			if popupShowing:
				emit_signal("HideInfoDisplay")
				popupShowing = false
			else:
				SendInfoToPopup()
				popupShowing = true
		
		#call the popup thing
	

func SendInfoToPopup():
	#use cardType to figure out what signal to emit
	if cardType == "Location" or cardType == "Strategy":
		emit_signal("ShowStrategyOrLocationCard", cardName, cardDescription, cardPicture)
	elif cardType == "Battle":
		emit_signal("ShowBattleCard", cardName, cardDescription, cardPicture, attribute)
	elif cardType == "Monster":
		emit_signal("ShowMonsterCard", cardName, cardDescription, cardPicture, attribute, health)
	else:
		#there was a typo
		print("There was a typo with the cardType in DisplayCard as part of browse cards menu")


func _physics_process(_delta):
	#I'm only putting it in here so it constantly checks
	get_input()
   


func _on_DisplayCard_mouse_entered():
	mouseInTile = true


func _on_DisplayCard_mouse_exited():
	mouseInTile = false
	
func ReadLinesFromFile(fileName):
	var file = File.new()
	file.open(fileName, File.READ)
	var content = []
	#check for empty lines! reading etc the file will add an empty line onto the end of it
	var line = ""
	while file.eof_reached() == false:
		line = file.get_line()
		if line == "":
			#it's an empty line, ignore it
			pass
		else:
			content.append(line)
			
	file.close()
	
	return content
