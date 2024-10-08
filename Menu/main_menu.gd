extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$"MarginContainer/HboxContainer/Menu Options/Start".grab_focus()
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_start_pressed() -> void:
	get_tree().change_scene_to_file("res://Environment/level.tscn")
	


func _on_how_to_play_pressed() -> void:
	get_tree().change_scene_to_file("res://Menu/How_to_play.tscn")


func _on_quit_pressed() -> void:
	get_tree().quit()


func _on_start_mouse_entered() -> void:
	$"MarginContainer/HboxContainer/Menu Options/Start".grab_focus()


func _on_how_to_play_mouse_entered() -> void:
	$"MarginContainer/HboxContainer/Menu Options/How to play".grab_focus()


func _on_quit_mouse_entered() -> void:
	$"MarginContainer/HboxContainer/Menu Options/Quit".grab_focus()

func _on_start_mouse_exited() -> void:
	$"MarginContainer/HboxContainer/Menu Options/Start".release_focus()
	
	
func _unhandled_key_input(event):
	if event.is_pressed():
		if $"MarginContainer/HboxContainer/Menu Options/Start".has_focus() != true:
			$"MarginContainer/HboxContainer/Menu Options/Start".grab_focus()


func _on_how_to_play_mouse_exited() -> void:
	$"MarginContainer/HboxContainer/Menu Options/How to play".release_focus()


func _on_quit_mouse_exited() -> void:
	$"MarginContainer/HboxContainer/Menu Options/Quit".release_focus()
