extends Node


var rng = RandomNumberGenerator.new()
var firstAttack = [1, "Violent Thrash", 80, "Beast", "this attack has a 1 in 3 chance to hit", true, true]



var secondAttack = [2, "Savage Rage", 90, "Beast", "this attack has a 1 in 4 chance to hit", true, true]

#effect enabled(bool), attack enabled(bool)
#index, name string, damage, attribute, effect text, effect enabled(bool), attack enabled(bool)
#ex. 1, "flaming Sting", 60, "Inferno", "there is a one in eight chance this attack does 100 damage", true, true

func _ready():
	rng.randomize()
	
#all monster cards will have a FirstAttack, SecondAttack and ThirdAttack functions
#if the card has an effect, the func will be called to do the attack, otherwise just the damage needs to be done

func GetAttacksForDisplay():
	
	return [firstAttack, secondAttack]

func FirstAttack(filteredAttack):
	#do random stuff and filter if it happens
	var randomNum = rng.randi_range(1, 3) #according to docs this range is inclusive
	
	#1 in 3 chance
	if randomNum == 3:
		#the attack hit
		pass
	else:
		#it missed 
		filteredAttack[2] = 0
		
	return filteredAttack
	
func SecondAttack(filteredAttack):
	#do random stuff and filter if it happens
	var randomNum = rng.randi_range(1, 4) #according to docs this range is inclusive
	
	#1 in 4 chance
	if randomNum == 4:
		#the attack hit
		pass
	else:
		#it missed 
		filteredAttack[2] = 0
	
	
	
	return filteredAttack
	
func ThirdAttack(filteredAttack):
	return filteredAttack
