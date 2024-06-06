extends ColorRect

onready var game = $"../Game"

func _process(delta):
	if Input.is_action_just_pressed("Pause") and game.visible:
		get_tree().paused = !get_tree().paused
		visible = get_tree().paused
	if Input.is_action_just_pressed("Restart") and game.visible:
		game.StartNewGame()
