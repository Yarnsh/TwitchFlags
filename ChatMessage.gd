extends HBoxContainer

func set_msg(stamp : String, data : SenderData, msg : String, badges : String) -> void:
	$RichTextLabel.bbcode_text = stamp + " " + badges + "[b]" + data.user +"[/b]: " + msg
