extends TextureRect

const half_set_time = 0.1
var set_timer = -1.0
var new_flag = null

func SetFlag(flag):
	new_flag = flag
	set_timer = half_set_time * 2


func _process(delta):
	if set_timer >= half_set_time * 2.0:
		rect_scale = Vector2.ONE
	elif set_timer >= half_set_time:
		rect_scale = Vector2.ONE * ((set_timer - half_set_time)/half_set_time)
	elif set_timer >= 0.0:
		if new_flag != null:
			texture = new_flag
			new_flag = null
		rect_scale = Vector2.ONE * (1.0 -(((set_timer)/half_set_time)))
	else:
		rect_scale = Vector2.ONE
	
	set_timer -= delta
