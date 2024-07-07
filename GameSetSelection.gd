extends OptionButton


# Declare member variables here. Examples:
# var a = 2
# var b = "text"



func reload_options():
	clear()
	for set_name in Flags.name_to_flag_set.keys():
		add_item(set_name)
	select(0)

# Called when the node enters the scene tree for the first time.
func _ready():
	Flags.connect("new_flag_set", self, "reload_options")


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
