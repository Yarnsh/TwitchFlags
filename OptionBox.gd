extends Control

export var number = 1

onready var number_label = $Number
onready var option_container = $Option1/Option
onready var votes = $Votes
onready var start_pos = rect_position
var new_text = null
const half_move_time = 0.15
const move_offset = Vector2.DOWN * 500.0
var move_timer = half_move_time

# Called when the node enters the scene tree for the first time.
func _ready():
	number_label.text = str(number) + ")"

func GetOptionText():
	return option_container.option.text

func SetOption(set_text, extra_delay):
	new_text = set_text
	move_timer = (half_move_time * 2.0) + extra_delay

func SetVotes(vote_count):
	votes.SetText(str(vote_count))

func _process(delta):
	if move_timer >= half_move_time * 2.0:
		rect_position = start_pos
	elif move_timer >= half_move_time:
		rect_position = start_pos + (move_offset * (1.0 - ((move_timer - half_move_time)/half_move_time)))
	elif move_timer >= 0.0:
		if new_text != null:
			option_container.option.SetText(new_text)
			votes.SetText("0")
			new_text = null
		rect_position = start_pos + move_offset - (move_offset * (1.0 - (move_timer/half_move_time)))
	else:
		rect_position = start_pos
	
	move_timer -= delta

func SetNormalColoring():
	option_container.self_modulate = Color.white
	option_container.modulate = Color.white
	
func SetFadedColoring():
	option_container.modulate = Color.darkgray

func SetCorrectColoring():
	option_container.self_modulate = Color.chartreuse
	option_container.modulate = Color.chartreuse

func SetWrongColoring():
	option_container.self_modulate = Color.crimson
	option_container.modulate = Color.crimson
