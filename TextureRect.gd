extends TextureRect

func _ready():
	# Ustaw teksturę
	texture = preload("res://assets/maps/jungle/elementy/dzień.png")
	
	# Ustaw tryb rozciągania na Tile
	stretch_mode = TextureRect.STRETCH_TILE
	
	# Ustawienie kotwic na pełny prostokąt
	set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	
	# Ustawienie minimalnego rozmiaru na rozmiar okna
	custom_minimum_size = get_viewport().size
