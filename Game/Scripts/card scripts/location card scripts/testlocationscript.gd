extends Node


func _ready():
	pass
	
func ConnectSignalsFromRoot(root):
	root.connect("battleStart", self, "OnBattleStart")
	root.connect("battleCardUsed", self, "OnBattleCardUsed")
	root.connect("battleEnd", self, "OnBattleEnd")



func OnBattleStart(gameState, battleCardId):
	print("battle started")
	
func OnBattleCardUsed(gameState, battleCardId):
	print("battle card used")
	
func OnBattleEnd(gameState, battleCardId):
	print("battle ended")
