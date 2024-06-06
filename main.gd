extends Node2D
@onready var options_button = $CanvasLayer/OptionsButtonContainer/OptionsButton
@onready var control_node = $Control
@onready var canvas_layer = $CanvasLayer

func _ready():
	print("Main scene ready.")
	print("Control node:", control_node)
	if not ProjectSettings.has_setting("application/volume"):
		ProjectSettings.set_setting("application/volume", -10.0)  # Domyślna wartość głośności to -10 dB
		ProjectSettings.save()
	
	var volume = ProjectSettings.get_setting("application/volume")
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), volume)
	
	var caps_nodes = get_tree().get_nodes_in_group("caps")
	for cap in caps_nodes:
		cap.connect("caps_collected", Callable(self, "_on_caps_collected"))
		print("Caps connected for collision detection.")
		
	print("Node2D _ready() called")
	if canvas_layer == null:
		print("Error: canvas_layer is null")
	else:
		canvas_layer.connect("options_pressed", Callable(self, "_on_options_pressed"))

func _on_options_pressed():
	print("_on_options_pressed() called in Node2D")
	var tree = get_tree()
	if tree == null:
		print("Error: get_tree() returned null in Node2D")
	else:
		print("get_tree() returned a valid reference in Node2D")
		var result = tree.change_scene("res://Options.tscn")  # Użycie change_scene zamiast change_scene_to_file
		if result != OK:
			print("Failed to change scene, result: ", result)
		else:
			print("Scene changed successfully")

func _on_caps_collected():
	print("Caps collected!")
	control_node.add_caps()
	

