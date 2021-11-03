extends Control

var imageList = []
var textList = []

var imagesPath = "res://Game/Assets/Images/Experimental/"

var index = 0

func _ready():
	Settings.SetButtonToTheme($BackButton)
	Settings.SetButtonToTheme($NextButton)
	Settings.SetButtonToTheme($LastButton)
	Settings.SetPanelToTheme($Panel)
	
	LoadStuff()
	
	var returnedVals = MusicManager.GetCurrentMenuMusic()	#first is music, second is position in song
	var song = returnedVals[0]
	var songPos = returnedVals[1]
	$MenuMusic.stream = song
	$MenuMusic.play(songPos)
	
	
	
func LoadStuff():
	LoadText()
	LoadImages()
	LoadCurrent()
	
func LoadCurrent():
	$HelpImage/battle1.texture = load(imageList[index])
	$HelpText.text = textList[index]
	
func LoadText():
	var setupOneMessage = "This is the setup phase, the first phase of the game. In setup phase, each player takes a turn placing a red location card onto a grey location card dock to setup the field. You can place a location card on a location card dock by clicking and dragging it over a grey square and then releasing the left mouse button."
	textList.append(setupOneMessage)
	
	var setupTwoMessage = "Once you have done this, you will notice that the turn guide now says to end your turn. The only thing each player does in the setup phase is a place one location card. This only happens once at the start of the game, the rest of the game will have fuller turns. Notice how the grey location card dock changes, this means the card is placed there."
	textList.append(setupTwoMessage)
	
	var setupThreeMessage = "Use WASD or the arrow keys to move the camera over to the right and click the END PHASE button to end your turn. Since it is the setup phase, it will now switch over to player two's setup phase. After player two's setup phase it will be your location card phase, this is similar to the setup phase and requires the same actions, except you don't have to place a location card if you don't want to in the location card phase. You only have to in the setup phase in order to setup the board."
	textList.append(setupThreeMessage)
	
	var monsterOneMessage = "Now after the location card phase, it's the monster card phase! If you choose to, you can place a monster card on any location card dock with a location card docked in it. You can see your monster card by clicking the 'Monster Card' button in the card dock."
	textList.append(monsterOneMessage)
	
	var monsterTwoMessage = "Once you place the monster card on the dock, you will see it come to life and some information about it. Once you have placed a monster you must end your turn."
	textList.append(monsterTwoMessage)
	
	var battleOneMessage = "If during a monster card phase you place a monster card onto a card which already has another player's monster on it, you will start a battle."
	textList.append(battleOneMessage)
	
	var battleTwoMessage = "Once both monsters are places on the card, you will see the location card reveal itself and the turn phase change to the monster attack phase. Right click on a monster to open the monster attack menu. The END PHASE button may not work to end your turn, this is what the skip button is for."
	textList.append(battleTwoMessage)
	
	var battleThreeMessage = "Once you right click on your monster you will see a menu like this: the monster attack menu. Here you will see your attack options as well as the option to skip this battle phase. The numbers you see here might not always be the same as on the card, because they may have been altered by card effects, so watch out!"
	textList.append(battleThreeMessage)
	
	var battleFourMessage = "After the monster attack phase comes the battle card phase. You can find battle cards by clicking on the 'Battle Card' button in the card dock. If you want to use one, click and drag it over to the dock where the battle is happening and release it, if it can be played it will be played and if not it won't be used and you can play another. If you don't want to play a battle card just end your turn. After this phase, your opponent will have their battle phases, the battle keeps going until one monster reaches a health of zero, which means the other player wins the battle!"
	textList.append(battleFourMessage)
	
	var strategyOneMessage = "The last non-battle phase is the strategy card phase and it happens after the monster card phase. If you want to you may play a strategy card, they can be found by clicking the 'Strategy Card' button on the card dock. Once this phase is over, it will switch over to your opponents turn."
	textList.append(strategyOneMessage)
	
	
func LoadImages():
	imageList.append(imagesPath+"setup1.png")
	imageList.append(imagesPath+"setup2.png")
	imageList.append(imagesPath+"setup3.png")
	imageList.append(imagesPath+"monster1.png")
	imageList.append(imagesPath+"monster2.png")
	imageList.append(imagesPath+"battle1.png")
	imageList.append(imagesPath+"battle2.png")
	imageList.append(imagesPath+"battle3.png")
	imageList.append(imagesPath+"battle4.png")
	imageList.append(imagesPath+"strat1.png")
	
	



func _on_NextButton_pressed():
	
	if index < (len(imageList)-1):
		index += 1
	else:
		pass
	
	LoadCurrent()

func _on_LastButton_pressed():
	if index > 0:
		index -= 1
	else:
		pass

	LoadCurrent()

func _on_BackButton_pressed():
	MusicManager.SetMenuMusicPlaybackPosition($MenuMusic.get_playback_position())
	get_tree().change_scene("res://Game/Scenes/Main/MainMenuAndSubMenus/MainMenu.tscn")

