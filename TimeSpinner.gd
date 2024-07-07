extends Sprite

onready var start_rot = rotation
var rot = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _process(delta):
	if rot:
		if (rotation + 18.0 * delta) > start_rot + PI:
			rotation = start_rot
			rot = false
		else:
			rotation = (rotation + 10.0 * delta) 

func Spin():
	rot = true
