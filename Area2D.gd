extends Area2D

signal caps_collected

@onready var sound_manager = $"../../SoundManager"  # Odniesienie do SoundManager

func _ready():
	connect("body_entered", Callable(self, "_on_body_entered"))
	print("Caps script is ready")
	if sound_manager:
		print("SoundManager found")
	else:
		print("Error: SoundManager not found")
	
func _on_body_entered(body):
	print("Caps collided with: ", body.name)
	if body.is_in_group("player"):
		print("Collided with player")
		emit_signal("caps_collected")
		if sound_manager:
			print("Calling play_collect_sound on SoundManager")
			sound_manager.call("play_collect_sound")  # Użycie call, aby upewnić się, że funkcja istnieje
		else:
			print("Error: SoundManager is null")
		print("Caps collected signal emitted")
		queue_free()  # Usunięcie monety natychmiast po odtworzeniu dźwięku
	else:
		print("Collided with non-player object")
