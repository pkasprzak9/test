extends AudioStreamPlayer

func _ready():
	play()  # Odtwórz muzykę przy starcie

func play_music():
	if not is_playing():
		play()
		print("Playing background music")

func stop_music():
	if is_playing():
		stop()
		print("Stopping background music")
