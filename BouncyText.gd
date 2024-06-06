extends Label

var bounce_time = -1.0
onready var start_rot = rect_rotation

func SetText(new_text, force=false):
	if text != new_text or force:
		text = new_text
		bounce_time = 0.1

func _process(delta):
	if bounce_time >= 0.06:
		rect_scale = Vector2.ONE * (1.5 - ((0.5 / 0.04) * (bounce_time - 0.06)))
	elif bounce_time >= 0.0:
		rect_scale = Vector2.ONE * (1.5 + ((0.5 / 0.06) * (bounce_time)))
	else:
		rect_scale = Vector2.ONE
	
	if bounce_time > 0:
		rect_rotation = start_rot + (sin(bounce_time * 20.0) * 2.0)
	else:
		rect_rotation = start_rot
	
	bounce_time -= delta
