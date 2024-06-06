extends CharacterBody2D

@onready var _animated_sprite = $AnimatedSprite2D
@onready var _running_sound = $RunningSound  # Zaktualizowane odniesienie do RunningSound
@onready var _jump_sound = $JumpSound  # Odniesienie do JumpSound

var gravity = 1400
var my_velocity = Vector2.ZERO
var max_horizontal_speed = 800
var jump_speed = 1000
var horizontal_acceleration = 600
var jump_termination_multiplier = 3
var max_fall_speed = 2000  # Nowa zmienna maksymalnej prędkości opadania

@export var max_health: int = 100
var current_health: int

@export var death_y_threshold: float = 800.0  # Krytyczna wartość osi Y (dodatnia)

signal player_died

var has_jumped = false  # Flaga skoku
var is_moving = false  # Flaga poruszania się

func _ready():
	current_health = max_health
	var control_node = get_parent().get_node("Control")
	if control_node != null:
		connect("player_died", Callable(control_node, "_on_player_died"))
		print("Connected player_died signal to Control node.")
	else:
		print("Error: Control node not found.")
	print("Player ready with max health: ", max_health)
	print("death_y_threshold set to: ", death_y_threshold)
	print("Player initial position: ", global_position)  # Dodano debugowanie początkowej pozycji gracza

func _process(delta):
	var move_vector = Vector2.ZERO
	move_vector.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	
	# Animacja skoku
	if not is_on_floor() and not has_jumped:
		_animated_sprite.play("jump")
		has_jumped = true
	elif is_on_floor() and has_jumped:
		has_jumped = false

	# Odwracanie sprite'a i animacja ruchu
	if is_on_floor():
		if move_vector.x > 0:
			_animated_sprite.play("run")
			_animated_sprite.flip_h = false  # Odwróć sprite'a w prawo
		elif move_vector.x < 0:
			_animated_sprite.play("run")
			_animated_sprite.flip_h = true  # Odwróć sprite'a w lewo
		else:
			_animated_sprite.stop()
	
	if Input.is_action_just_pressed("jump") and is_on_floor():
		my_velocity.y = -jump_speed
		if _jump_sound:
			print("Playing jump sound")
			_jump_sound.play()  # Odtwórz dźwięk skoku
	
	my_velocity.x += move_vector.x * horizontal_acceleration * delta
	
	if move_vector.x == 0:
		my_velocity.x = lerp(0.0, my_velocity.x, pow(2, -40 * delta))
		
	my_velocity.x = clamp(my_velocity.x, -max_horizontal_speed, max_horizontal_speed)
	
	if my_velocity.y < 0 and not Input.is_action_pressed("jump"):
		my_velocity.y += gravity * jump_termination_multiplier * delta
	else:
		my_velocity.y += gravity * delta
	
	# Ograniczenie prędkości opadania
	my_velocity.y = min(my_velocity.y, max_fall_speed)
		
	set_velocity(my_velocity)
	set_up_direction(Vector2.UP)
	move_and_slide()
	my_velocity = get_velocity()

	# Dźwięk poruszania się
	if move_vector != Vector2.ZERO and is_on_floor():
		if not is_moving:
			is_moving = true
			if _running_sound and not _running_sound.playing:
				print("Playing movement sound")
				_running_sound.play()
	else:
		if is_moving:
			is_moving = false
			if _running_sound and _running_sound.playing:
				print("Stopping movement sound")
				_running_sound.stop()
	
	print("Current player position: ", global_position)  # Dodano debugowanie aktualnej pozycji gracza
	if global_position.y > death_y_threshold:  # Poprawiono warunek sprawdzania
		print("Player crossed death threshold. Global position: (", global_position.x, ", ", global_position.y, ")")
		die()

func take_damage(damage: int):
	current_health -= damage
	print("Player took damage: ", damage, " Current health: ", current_health)
	if current_health <= 0:
		die()
	else:
		print("Player health: " + str(current_health))

func die():
	print("Player died")  # Komunikat debugowy
	emit_signal("player_died")
	print("Player death signal emitted")  # Dodano debugowanie emisji sygnału
	queue_free()
