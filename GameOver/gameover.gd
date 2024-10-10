extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass



func _on_retry_pressed() -> void:
	get_tree().change_scene_to_file("res://Environment/level.tscn")

# Called when quit button is pressed
func _on_quit_pressed() -> void:
	get_tree().quit()


func _on_retry_mouse_entered() -> void:
	$"MarginContainer/HBoxContainer/Buttons/Retry".grab_focus()


func _on_quit_mouse_entered() -> void:
	$"MarginContainer/HBoxContainer/Buttons/Quit".grab_focus()


func _on_retry_mouse_exited() -> void:
	$"MarginContainer/HBoxContainer/Buttons/Retry".release_focus()


func _on_quit_mouse_exited() -> void:
	$"MarginContainer/HBoxContainer/Buttons/Quit".release_focus()

func _unhandled_key_input(event):
	if event.is_pressed():
		if $"MarginContainer/HBoxContainer/Buttons/Retry".has_focus() != true and $"MarginContainer/HBoxContainer/Buttons/Quit".has_focus() != true:
			$"MarginContainer/HBoxContainer/Buttons/Retry".grab_focus()
