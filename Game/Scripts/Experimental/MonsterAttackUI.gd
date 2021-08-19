extends Control

#attack one
onready var attackOneLabel = $Panel/AttackLabelOne
onready var attackOneButton = $Panel/AttackOneAccept
onready var attackOneEffectText = $Panel/AttackOneScrollContainer/AttackOneScrollingText
onready var attackOneContainer = $Panel/AttackOneScrollContainer
onready var attackOneComponents = [attackOneLabel, attackOneButton, attackOneEffectText, attackOneContainer]

#attack two
onready var attackTwoLabel = $Panel/AttackLabelTwo
onready var attackTwoButton = $Panel/AttackTwoAccept
onready var attackTwoEffectText = $Panel/AttackTwoScrollContainer/AttackTwoScrollingText
onready var attackTwoContainer = $Panel/AttackTwoScrollContainer
onready var attackTwoComponents = [attackTwoLabel, attackTwoButton, attackTwoEffectText, attackTwoContainer]

#attack three
onready var attackThreeLabel = $Panel/AttackLabelThree
onready var attackThreeButton = $Panel/AttackThreeAccept
onready var attackThreeEffectText = $Panel/AttackThreeScrollContainer/AttackThreeScrollingText
onready var attackThreeContainer = $Panel/AttackThreeScrollContainer
onready var attackThreeComponents = [attackThreeLabel, attackThreeButton, attackThreeEffectText, attackThreeContainer]

func _ready():
	#there may be 0,1,2 or three attacks with or without effects
	#if there is less than 3 attacks, hide the unneeded attack assets/components
	LoadAttack(["Fire Breath 60 (Inferno)", "this attack will do no damage to other inferno types"], attackOneComponents)
	LoadAttack(["Water Breath 60 (water)", "this attack will do no damage to other water types"], attackTwoComponents)
	LoadAttack(["slap 20 (normal)", "this attack does no damage to other normal types"], attackThreeComponents)
	
	HideAttack(attackOneComponents)
	HideAttack(attackTwoComponents)
	HideAttack(attackThreeComponents)
	
func LoadAttack(attack, attackAssets):
	#attackAssets is one of the attack components things
	attackAssets[0].text = attack[0]	#set main text
	attackAssets[2].text = attack[1] 	#set effect text

func HideAttack(attackAssets):
	for x in range(len(attackAssets)):
		#max is exclusive
		#this might not work for buttons, since they have other stuff and might still detect the click on
		attackAssets[x].hide()
