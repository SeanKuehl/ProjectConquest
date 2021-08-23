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
var loadedAttacks = []	#keep this to check which are enabled/disabled for selection

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
	
	HideAttackSpotsBasedOnAttacks(monsterAttacks)
	#each attack is in the form [1, "flaming Sting", 60, "Inferno", "there is a one in eight chance this attack does 100 damage", true, true]
	#there could be 1,2 or 3 attacks
	#print(monsterAttacks)
	for attack in monsterAttacks:
		#print(attack)
		if numberOfAttacks == 0:
			LoadAttack(attack, attackOneComponents)
			
		if numberOfAttacks == 1:
			LoadAttack(attack, attackTwoComponents)
			
		if numberOfAttacks == 2:
			LoadAttack(attack, attackThreeComponents)
			
		numberOfAttacks += 1
		
	numberOfAttacks = 0	#reset for next time
	loadedAttacks = monsterAttacks
	
	
func LoadAttack(attack, attackAssets):
	#attackAssets is one of the attack components things
	
	if attack[6]:
		#attack is enabled, no change
		pass
	else:
		#attack is disabled and can't be picked set the button to disabled
		attackAssets[1].disabled = true
	
	#last two are null for some reason
	attackAssets[0].text = attack[1] +" "+ str(attack[2])+" " + str(attack[3])	#set main text
	if attack[5]:
		#if effect is enabled, show it
		attackAssets[2].text = attack[4] 	#set effect text
	else:
		#don't show it since it wouldn't happen
		pass

func HideAttack(attackAssets):
	for x in range(len(attackAssets)):
		#max is exclusive
		#this might not work for buttons, since they have other stuff and might still detect the click on
		attackAssets[x].hide()
		
func HideAttackSpotsBasedOnAttacks(attacks):
	var numberOfAttacks = len(attacks)
	
	if numberOfAttacks == 2:
		HideAttack(attackThreeComponents)
	if numberOfAttacks == 1:
		HideAttack(attackThreeComponents)
		HideAttack(attackTwoComponents)
	if numberOfAttacks == 0:
		HideAttack(attackThreeComponents)
		HideAttack(attackTwoComponents)
		HideAttack(attackOneComponents)



func GetIfAttackSelectable(attackIndex):
	#this checks both that the index exists(there is no third attack if there is only 2 in the list
	#and that it's enabled(the attack is not disabled
	var numOfAttacks = len(loadedAttacks)
	
	if attackIndex <= numOfAttacks:
		
		#the attack exists, check if enabled
		var attack = loadedAttacks[attackIndex-1]	#-1 because lists start at zero
		
		if attack[6]:
			
			#the attack is enabled, return true
			return true
			
	return false	#one or more conditions weren't correct, return false
	



#when selecting an attack, ask the user if they want to confirm the attack
func _on_CloseButton_pressed():
	hide()
	set_process(false)
	set_physics_process(false)
	set_process_input(false)
				
	


func _on_Skip_pressed():
	
	attackSelected = 4
	
	
	get_parent().HandleMonsterAttackSelection([], true)
	
	#now call a root func or something so it can handle this information and 
	#change the battle state and start filtering


func _on_AttackThreeAccept_pressed():
	#check if attack is disabled, or whether or not there is a third attack
	attackSelected = 3
	var attackCanBeDone = GetIfAttackSelectable(attackSelected)
	#if attackCanBeDone:
	#call func to do attack
	if attackCanBeDone:
		
		get_parent().HandleMonsterAttackSelection(loadedAttacks[attackSelected-1], false)
	


func _on_AttackTwoAccept_pressed():
	attackSelected = 2
	var attackCanBeDone = GetIfAttackSelectable(attackSelected)
	if attackCanBeDone:
		
		get_parent().HandleMonsterAttackSelection(loadedAttacks[attackSelected-1], false)
	


func _on_AttackOneAccept_pressed():
	attackSelected = 1
	var attackCanBeDone = GetIfAttackSelectable(attackSelected)
	if attackCanBeDone:
		
		get_parent().HandleMonsterAttackSelection(loadedAttacks[attackSelected-1], false)
	
	
	
#hide attack slots that are unused, disable and don't use button for disabled attacks, don't display disabled effects
