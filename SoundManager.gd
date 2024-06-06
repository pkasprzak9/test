extends Node

@onready var collect_sound_player = $CollectSoundPlayer

func _ready():
	if collect_sound_player:
		print("CollectSoundPlayer loaded: ", collect_sound_player.stream)
	else:
		print("Error: CollectSoundPlayer not found")

func play_collect_sound():
	if collect_sound_player:
		collect_sound_player.play()
		print("Playing collect sound")
	else:
		print("Error: CollectSoundPlayer is null")
