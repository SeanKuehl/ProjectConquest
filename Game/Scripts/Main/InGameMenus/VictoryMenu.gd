extends Control

onready var victoryLabel = $VictoryMessage



func _ready():
	pass
	
func SetWhoWon(player):
	victoryLabel.text = player + " has won the game! Congratulations!"


func _on_QuitButton_pressed():
	get_tree().quit()	#exit the game
