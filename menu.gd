extends Control

@onready var options_button = $VBoxContainer/OptionsButton

func _ready():
	options_button.connect("pressed", Callable(self, "_on_options_pressed"))

func _on_start_pressed():
	get_tree().change_scene_to_file("res://main.tscn")

func _on_quit_button_pressed():
	get_tree().quit()

func _on_options_pressed():
	get_tree().change_scene_to_file("res://Options.tscn")
