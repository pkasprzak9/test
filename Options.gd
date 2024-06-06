extends Control

@onready var back_button = $VBoxContainer/BackButton
@onready var volume_slider = $VBoxContainer/VolumeSlider

func _ready():
	back_button.connect("pressed", Callable(self, "_on_back_button_pressed"))
	volume_slider.connect("value_changed", Callable(self, "_on_volume_slider_value_changed"))
	volume_slider.value = get_volume()

func _on_back_button_pressed():
	get_tree().change_scene_to_file("res://main.tscn")

func _on_volume_slider_value_changed(value):
	print("Volume changed to: ", value)
	set_volume(value)

func get_volume():
	if ProjectSettings.has_setting("application/volume"):
		return ProjectSettings.get_setting("application/volume")
	else:
		return 0.0 

func set_volume(value):
	ProjectSettings.set_setting("application/volume", value)
	ProjectSettings.save()
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), value)
