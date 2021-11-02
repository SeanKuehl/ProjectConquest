extends CanvasLayer

onready var label = $GuideLabel
onready var advice = $AdviceLabel

func _ready():
	pass


func _physics_process(_delta):
	#turn state, battle state, player turn, player battle turn
	#if there is a battle going on, show player battle turn - battle state
	#otherwise show player turn - turn state
	
	#set the advice for what the player should do
	#advice.text = GameState.HudGetAdvice()	
	
	if GameState.GetBattleState() == "":
		#then no battle is going on, show "player turn - turn state"
		var textToShow = ""
		
		if GameState.GetTurnOver() == true:
			textToShow += GameState.GetCurrentTurn() + " - " + GameState.GetTurnState() +  ", end your turn" + "\n"
		else:
			textToShow += GameState.GetCurrentTurn() + " - " + GameState.GetTurnState() + "\n"
		
		textToShow += "You have "+ str(GameState.GetPlayerVictoryPoints(GameState.GetCurrentTurn())) + " victory points"
		label.text = textToShow
		
	
		
	else:
		#there is a battle going on, show "player battle turn - battle state"
		var textToShow = ""
		
		if GameState.GetTurnOver() == true:
			textToShow += GameState.GetPlayerBattleTurn() + " - " + GameState.GetBattleState() +  ", end your turn"+ "\n"
		else:
			textToShow += GameState.GetPlayerBattleTurn() + " - " + GameState.GetBattleState() + "\n"
		
		
		textToShow += "You have "+ str(GameState.GetPlayerVictoryPoints(GameState.GetPlayerBattleTurn())) + " victory points"
		label.text = textToShow
	
	
