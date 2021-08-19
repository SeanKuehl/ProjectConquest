extends Control

onready var thisNode = get_node("../"+name)

#attack one
onready var attackOneLabel = $Panel/AttackLabelOne
onready var attackOneButton = $Panel/AttackOneAccept
onready var attackOneEffectText = $AttackOneScrollContainer/AttackOneScrollingText
onready var attackOneContainer = $AttackOneScrollContainer
onready var attackOneComponents = [attackOneLabel, attackOneButton, attackOneEffectText, attackOneContainer]

#attack two
onready var attackTwoLabel = $Panel/AttackLabelTwo
onready var attackTwoButton = $Panel/AttackTwoAccept
onready var attackTwoEffectText = $AttackTwoScrollContainer/AttackTwoScrollingText
onready var attackTwoContainer = $AttackTwoScrollContainer
onready var attackTwoComponents = [attackTwoLabel, attackTwoButton, attackTwoEffectText, attackTwoContainer]

#attack three
onready var attackThreeLabel = $Panel/AttackLabelThree
onready var attackThreeButton = $Panel/AttackThreeAccept
onready var attackThreeEffectText = $AttackThreeScrollContainer/AttackThreeScrollingText
onready var attackThreeContainer = $AttackThreeScrollContainer
onready var attackThreeComponents = [attackThreeLabel, attackThreeButton, attackThreeEffectText, attackThreeContainer]

#when they select an attack, ask them with a popup if they're sure, if they are then call a function with the info
#of what attack is selected. This will proceed with the battle and change battleState

var numberOfAttacks = 0
var attackSelected = 0	#this is either 1,2,3 or if skip then 4

func _ready():
	#there may be 0,1,2 or three attacks with or without effects
	#if there is less than 3 attacks, hide the unneeded attack assets/components
	#LoadAttack(["Fire Breath 60 (Inferno)", "this attack will do no damage to other inferno types"], attackOneComponents)
	#LoadAttack(["Water Breath 60 (water)", "this attack will do no damage to other water types"], attackTwoComponents)
	#LoadAttack(["slap 20 (normal)", "this attack does no damage to other normal types"], attackThreeComponents)
	pass
	#HideAttack(attackOneComponents)
	#HideAttack(attackTwoComponents)
	#HideAttack(attackThreeComponents)
	
func LoadMonsterAttacks(monsterAttacks):
	#[[name, damage, attribute, description], ...]
	#there could be 1,2 or 3 attacks
	
	for attack in monsterAttacks:
		if numberOfAttacks == 0:
			LoadAttack(attack, attackOneComponents)
			
		if numberOfAttacks == 1:
			LoadAttack(attack, attackTwoComponents)
			
		if numberOfAttacks == 2:
			LoadAttack(attack, attackThreeComponents)
			
		numberOfAttacks += 1
	
	
	
	
func LoadAttack(attack, attackAssets):
	#attackAssets is one of the attack components things
	
	#last two are null for some reason
	attackAssets[0].text = attack[0] +" "+ str(attack[1])+" " + str(attack[2])	#set main text
	attackAssets[2].text = attack[3] 	#set effect text

func HideAttack(attackAssets):
	for x in range(len(attackAssets)):
		#max is exclusive
		#this might not work for buttons, since they have other stuff and might still detect the click on
		attackAssets[x].hide()

#when selecting an attack, ask the user if they want to confirm the attack
func _on_CloseButton_pressed():
	hide()
	set_process(false)
	set_physics_process(false)
	set_process_input(false)
				
	print("x")


func _on_Skip_pressed():
	attackSelected = 4
	print(4)
	#now call a root func or something so it can handle this information and 
	#change the battle state and start filtering


func _on_AttackThreeAccept_pressed():
	attackSelected = 3
	print(3)


func _on_AttackTwoAccept_pressed():
	attackSelected = 2
	print(2)


func _on_AttackOneAccept_pressed():
	attackSelected = 1
	print(1)
