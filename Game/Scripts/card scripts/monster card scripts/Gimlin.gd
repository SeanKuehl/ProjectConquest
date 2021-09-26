extends Node



var firstAttack = [1, "Magic Missile", 40, "Mystic", "", true, true]



var secondAttack = [2, "Wack", 30, "Normal", "", true, true]

#effect enabled(bool), attack enabled(bool)
#index, name string, damage, attribute, effect text, effect enabled(bool), attack enabled(bool)
#ex. 1, "flaming Sting", 60, "Inferno", "there is a one in eight chance this attack does 100 damage", true, true

func _ready():
	pass
	
#all monster cards will have a FirstAttack, SecondAttack and ThirdAttack functions
#if the card has an effect, the func will be called to do the attack, otherwise just the damage needs to be done

func GetAttacksForDisplay():
	
	return [firstAttack, secondAttack]

func FirstAttack(filteredAttack):
	#one in eight chance this attack does 100 damage, check if effect and attack are enabled and damage isn't already that strong
	#make sure to check if the attack is enabled!
	#this could also be used for a different effect besides filtering/changing the attack
	
	#if both the attack and effect are enabled
	#if filteredAttack[5] and filteredAttack[6]:
		#if the attack isn't already at or over 100 damage
		#if filteredAttack[2] < 100:
			#for x in range(20):
			#	var my_random_number = rng.randi_range(1, 8)	#inclusive
				#print("random num is: "+str(my_random_number))
			#filteredAttack[2] = 40	#for testing, forget the randomness
	
	return filteredAttack
	
func SecondAttack(filteredAttack):
	
	
	
	
	return filteredAttack
	
func ThirdAttack(filteredAttack):
	return filteredAttack
