extends Control

@onready var start: TextureButton = $"MarginContainer/VBoxContainer/HboxContainer/Menu Options/Start"
@onready var how_to_play: TextureButton = $"MarginContainer/VBoxContainer/HboxContainer/Menu Options/How to play"
@onready var quit: TextureButton = $"MarginContainer/VBoxContainer/HboxContainer/Menu Options/Quit"

	#@onready var start: TextureButton = $"MarginContainer/VBoxContainer/HboxContainer/Menu Options/Start"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	start.grab_focus()
	pass
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
	start.grab_focus()


func _on_how_to_play_mouse_entered() -> void:
	how_to_play.grab_focus()


func _on_quit_mouse_entered() -> void:
	quit.grab_focus()

func _on_start_mouse_exited() -> void:
	start.release_focus()
	
	
func _unhandled_key_input(event):
	if event.is_pressed():
		if start.has_focus() != true and how_to_play.has_focus() != true and quit.has_focus() != true:
			start.grab_focus()


func _on_how_to_play_mouse_exited() -> void:
	how_to_play.release_focus()


func _on_quit_mouse_exited() -> void:
	quit.release_focus()
