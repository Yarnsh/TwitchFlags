extends Gift

func _ready() -> void:
	connect_to_twitch()
	yield(self, "twitch_connected")
	
	unauthenticated_login()
	if(yield(self, "login_attempt") == false):
	  print("Invalid username or token.")
	  return
	
	connect("chat_message", get_parent(), "chat_message")

func set_channel(channel):
	join_channel(channel)
	# TODO: check if the channel is valid
