extends Node

onready var game = $Game

func chat_message(data : SenderData, msg : String) -> void:
	game.ProcessMessage(data.user, msg)
