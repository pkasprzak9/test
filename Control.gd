extends Control

@onready var caps_label = $Label
@onready var death_label = $DeathLabel  # Etykieta do komunikatu śmierci
@onready var death_screen = $DeathScreen  # TextureRect do obrazu śmierci
@onready var player = $"../Player"  # Odniesienie do gracza
@onready var camera = $"../Player/Camera2D"  # Odniesienie do kamery w węźle gracza
@onready var death_sound = $DeathSound  # Odniesienie do AudioStreamPlayer
var caps_count = 0

var fade_duration = 1.0
var move_duration = 1.0

func _ready():
	print("Control ready")
	update_caps_count()
	death_label.hide()  # Ukryj etykietę śmierci na początku
	death_screen.modulate.a = 0.0  # Ustaw przezroczystość obrazu na 0
	print("DeathScreen initial visibility: ", death_screen.visible)
	print("DeathScreen texture: ", death_screen.texture)
	print("DeathScreen global position: ", death_screen.global_position)

func update_caps_count():
	print("Updating caps count label")
	caps_label.text = "Caps: " + str(caps_count)

func add_caps():
	caps_count += 1
	print("Caps added! New count: ", caps_count)
	update_caps_count()

func _on_player_died():
	print("Showing death message")  # Komunikat debugowy
	death_label.text = "You Died"
	death_label.show()
	death_screen.show()  # Pokaż obraz śmierci
	death_sound.play()  # Odtwórz dźwięk śmierci
	fade_in_death_screen()  # Uruchom efekt fade-in dla obrazu śmierci
	print("DeathScreen visibility after player death: ", death_screen.visible)
	print("DeathScreen texture after player death: ", death_screen.texture)
	print("DeathScreen global position after player death: ", death_screen.global_position)
	move_camera_to_death_screen()

func move_camera_to_death_screen():
	if player and camera:
		var start_position = camera.global_position
		var end_position = death_screen.global_position
		var elapsed_time = 0.0

		while elapsed_time < move_duration:
			if not player:  # Sprawdź, czy gracz nadal istnieje
				print("Player has been freed, aborting camera move")
				return
			var delta = get_process_delta_time()
			elapsed_time += delta
			var t = elapsed_time / move_duration
			camera.global_position = lerp(start_position, end_position, t)
			await get_tree().process_frame
		camera.global_position = end_position  # Upewnij się, że kamera kończy w odpowiedniej pozycji
		print("Moving camera to death screen position: ", death_screen.global_position)
	else:
		print("Error: Player or Camera2D not found.")

func fade_in_death_screen():
	var elapsed_time = 0.0

	while elapsed_time < fade_duration:
		var delta = get_process_delta_time()
		elapsed_time += delta
		var alpha = lerp(0.0, 1.0, elapsed_time / fade_duration)
		death_screen.modulate.a = alpha
		await get_tree().process_frame
	death_screen.modulate.a = 1.0  # Upewnij się, że obraz jest w pełni widoczny
	print("Fade-in for DeathScreen completed")
