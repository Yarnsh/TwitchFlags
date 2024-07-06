extends PanelContainer

onready var option = $Option
onready var start_pos = rect_position
var new_text = null
const half_move_time = 0.15
const move_offset = Vector2.DOWN * 500.0
var move_timer = half_move_time

func SetOption(set_text, extra_delay):
	new_text = set_text
	move_timer = (half_move_time * 2.0) + extra_delay

func SetNormalColoring():
	self_modulate = Color.cornflower
	modulate = Color.white
	
func SetFadedColoring():
	modulate = Color.gray

func SetCorrectColoring():
	self_modulate = Color.chartreuse
	modulate = Color.white

func SetWrongColoring():
	self_modulate = Color.crimson
	modulate = Color.gray
