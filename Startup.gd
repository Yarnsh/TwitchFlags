extends ColorRect

onready var game = $".."
onready var count = $StartupCount
var time_until = -1.0

func StartCount():
	show()
	time_until = 4.0
	count.SetText("3")

func _process(delta):
	if time_until >= 1.0:
		count.SetText(str(int(time_until)))
		show()
	elif time_until >= 0:
		count.SetText("GO!")
		show()
	else:
		if visible:
			game.state = 1
			game.until_next_state = game.timer_time
		hide()
	
	if visible:
		time_until -= delta
