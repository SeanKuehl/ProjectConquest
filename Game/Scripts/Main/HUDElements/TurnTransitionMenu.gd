extends CanvasLayer

onready var labelText = $Label
onready var nextTurnCountdown = $Timer
onready var myPanel = $Panel
var nextPlayer = ""

func _ready():
	HideMyStuff()
	

func ShowMyStuff():
	nextTurnCountdown.start()
	labelText.show()
	myPanel.show()

func SetWhoseTurnNext(playerWhoseTurnItIsNext):
	nextPlayer = playerWhoseTurnItIsNext
	
func HideMyStuff():
	labelText.hide()
	myPanel.hide()
	
func _physics_process(_delta):
	
	labelText.text = "Please hand things over to "+nextPlayer+", this menu will close in "+str(int(nextTurnCountdown.get_time_left()))
	if nextTurnCountdown.is_stopped():
		HideMyStuff()
	

	
	
