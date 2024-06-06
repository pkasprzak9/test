extends Camera2D

@onready var options_button = get_node("../../CanvasLayer/OptionsButtonContainer/OptionsButton")

func _ready():
	options_button.connect("pressed", Callable(self, "_on_options_button_pressed"))

func _on_options_button_pressed():
	get_tree().change_scene_to_file("res://Options.tscn")
