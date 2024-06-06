extends Control

onready var line = $LineEdit
onready var game = $"../Game"
onready var gift = $"../Gift"

func _on_Button_pressed():
	gift.set_channel(line.text)
	game.SetChannel(line.text)
	game.StartNewGame()
	game.show()
	hide()
