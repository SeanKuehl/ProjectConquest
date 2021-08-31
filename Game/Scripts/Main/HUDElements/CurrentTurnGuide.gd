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
	advice.text = GameState.HudGetAdvice()	
	
	if GameState.GetBattleState() == "":
		#then no battle is going on, show "player turn - turn state"
		var textToShow = GameState.GetCurrentTurn() + " - " + GameState.GetTurnState()
		label.text = textToShow
	else:
		#there is a battle going on, show "player battle turn - battle state"
		var textToShow = GameState.GetPlayerBattleTurn() + " - " + GameState.GetBattleState()
		label.text = textToShow
	
	
