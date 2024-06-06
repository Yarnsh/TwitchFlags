extends VBoxContainer

func put_chat(senderdata : SenderData, msg : String):
	var msgnode : Control = preload("res://ChatMessage.tscn").instance()
	var time = OS.get_time()
	var badges : String = ""
	
	var bottom : bool = $Chat/ScrollContainer.scroll_vertical == $Chat/ScrollContainer.get_v_scrollbar().max_value - $Chat/ScrollContainer.get_v_scrollbar().rect_size.y
	msgnode.set_msg(str(time["hour"]) + ":" + ("0" + str(time["minute"]) if time["minute"] < 10 else str(time["minute"])), senderdata, msg, badges)
	$Chat/ScrollContainer/ChatMessagesContainer.add_child(msgnode)
	yield(get_tree(), "idle_frame")
	if (bottom):
		$Chat/ScrollContainer.scroll_vertical = $Chat/ScrollContainer.get_v_scrollbar().max_value

class EmoteLocation extends Reference:
	var id : String
	var start : int
	var end : int

	func _init(emote_id, start_idx, end_idx):
		self.id = emote_id
		self.start = start_idx
		self.end = end_idx

	static func smaller(a : EmoteLocation, b : EmoteLocation):
		return a.start < b.start
