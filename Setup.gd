extends Control

onready var line = $LineEdit
onready var game = $"../Game"
onready var gift = $"../Gift"
onready var set_selection = $SetSelection

func _ready():
	for set_name in Flags.name_to_flag_set.keys():
		set_selection.add_item(set_name)
	set_selection.select(0)

func _on_Button_pressed():
	game.SetFlagSet(set_selection.get_selected_id())
	gift.set_channel(line.text)
	game.SetChannel(line.text)
	game.StartNewGame()
	game.show()
	hide()
