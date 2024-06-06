extends CanvasLayer

@onready var options_button = $OptionsButtonContainer/OptionsButton

signal options_pressed

func _ready():
	print("CanvasLayer _ready() called")
	if options_button == null:
		print("Error: options_button is null")
	else:
		print("options_button found")
		options_button.connect("pressed", Callable(self, "_emit_options_pressed"))

func _emit_options_pressed():
	print("_emit_options_pressed() called")
	emit_signal("options_pressed")

func _on_options_pressed():
	print("_on_options_pressed() called")
	var tree = get_tree()
	if tree == null:
		print("Error: get_tree() returned null")
	else:
		print("get_tree() returned a valid reference")
		tree.change_scene_to_file("res://Options.tscn")
