extends Node

#each attack(the version used for filtering) will have:
#index(first, second or third attack, replaced name), damage, attribute, whether or not it has a special effect(bool)

#each attack(regular version) will have:
#name, damage, attribute, description/effect(if there is one), designated function(for when/if the effect runs)

var firstAttackRegularVersion = ["Flaming Sting", 60, "Inferno", "there is a one in eight chance this attack does 100 damage"]
var firstAttackFilteringVersion = [1, 60, "Inferno", true]	#it's the first attack, does 60 damage, is inferno type and has an effect

var secondAttackRegularVersion = ["Stiff Punch", 40, "Normal", "if you landed on the card first, this attack does 60 damage"]
var secondAttackFilteringVersion = [2, 40, "Normal", true]

func _ready():
	pass
	
#all monster cards will have a FirstAttack, SecondAttack and ThirdAttack functions
#if the card has an effect, the func will be called to do the attack, otherwise just the damage needs to be done

func GetAttacksForDisplay():
	
	return [firstAttackRegularVersion, secondAttackRegularVersion]

func FirstAttack():
	print("first attack worked")
	
func SecondAttack():
	print("second attack worked")



