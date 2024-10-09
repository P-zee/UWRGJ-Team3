extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass



func _on_retry_pressed() -> void:
	get_tree().change_scene_to_file("res://Environment/level.tscn")

# Called when quit button is pressed
func _on_quit_pressed() -> void:
	get_tree().quit()


func _on_retry_mouse_entered() -> void:
	pass # Replace with function body.


func _on_quit_mouse_entered() -> void:
	pass # Replace with function body.
