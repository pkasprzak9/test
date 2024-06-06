extends Control

@onready var options_button = $OptionsButton

signal options_pressed

func _ready():
	print("OptionsButtonContainer _ready() called")
	if options_button == null:
		print("Error: options_button is null")
	else:
		print("options_button found")
		options_button.connect("pressed", Callable(self, "_emit_options_pressed"))

func _emit_options_pressed():
	print("_emit_options_pressed() called")
	emit_signal("options_pressed")
