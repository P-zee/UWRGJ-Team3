extends Control


# Called when the node enters the scene tree for the first time.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_back_mouse_entered() -> void:
	$TextureRect/MarginContainer/VBoxContainer/Back.grab_focus()

func _on_back_mouse_exited() -> void:
	$TextureRect/MarginContainer/VBoxContainer/Back.release_focus()
	
func _on_back_pressed() -> void:
	get_tree().change_scene_to_file("res://Menu/main_menu.tscn")
	
func _unhandled_key_input(event):
	if event.is_pressed():
		if $TextureRect/MarginContainer/VBoxContainer/Back.has_focus() != true:
			$TextureRect/MarginContainer/VBoxContainer/Back.grab_focus()
			
