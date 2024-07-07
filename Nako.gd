extends AnimatedSprite

var die_time = 0.0

# Called when the node enters the scene tree for the first time.
func _ready():
	die_time = Time.get_ticks_msec() + 5000
	position = Vector2((randf() * 800.0) + 100.0, (randf() * 400.0) + 100.0)
	rotation = randf() * PI * 2.0
	position += Vector2.RIGHT.rotated(rotation) * 1000.0


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position -= Vector2.RIGHT.rotated(rotation) * 800.0 * delta
