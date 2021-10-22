extends CanvasLayer

signal ShowHelp()

func _ready():
	pass


func _on_Button_pressed():
	var textToSend = GameState.HudGetAdvice()
	emit_signal("ShowHelp", textToSend)
	
	
	
	
	
