extends Node


var rng = RandomNumberGenerator.new()
var firstAttack = [1, "Metal Mallace", 50, "Mechanical", "this attack has a 1 in 3 chance to miss", true, true]



var secondAttack = [2, "Wallop", 30, "Normal", "", true, true]

#effect enabled(bool), attack enabled(bool)
#index, name string, damage, attribute, effect text, effect enabled(bool), attack enabled(bool)
#ex. 1, "flaming Sting", 60, "Inferno", "there is a one in eight chance this attack does 100 damage", true, true

func _ready():
	rng.randomize()
	
#all monster cards will have a FirstAttack, SecondAttack and ThirdAttack functions
#if the card has an effect, the func will be called to do the attack, otherwise just the damage needs to be done

func GetAttacksForDisplay():
	
	#this is done to dereference it so the original attack data isn't 
	#effected by any changes done during the filtering process
	var firstAttackToPass = []
	for x in firstAttack:
		firstAttackToPass.append(x)
		
	var secondAttackToPass = []
	for x in secondAttack:
		secondAttackToPass.append(x)
	
	return [firstAttackToPass, secondAttackToPass]

func FirstAttack(filteredAttack):
	#this attack has a 1 in 3 chance to miss
	
	#do random stuff and filter if it happens
	var randomNum = rng.randi_range(1, 3) #according to docs this range is inclusive
	
	#1 in 3 chance
	if randomNum == 3:
		#the attack missed
		filteredAttack[2] = 0
		
	else:
		#it hit, make no changes
		pass
		
		
	return filteredAttack
	
func SecondAttack(filteredAttack):
	
	
	return filteredAttack
	
func ThirdAttack(filteredAttack):
	return filteredAttack
