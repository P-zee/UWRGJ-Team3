extends Control
@onready var resumeButton: TextureButton = $MarginContainer/HBoxContainer/Buttons/Resume

func pause():
	get_tree().paused = true
	self.show()
	#AnimationPlayer.play("pause_blur")
	
func resume():
	get_tree().paused = false
	self.hide()
	#$AnimationPlayer.play_backwards("pause_blur")
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.hide()
	resumeButton.grab_focus()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("pause") and !get_tree().paused:
		pause()
	elif Input.is_action_just_pressed("pause") and get_tree().paused:
		resume()
	
func _on_resume_pressed() -> void:
	resume()

func _on_quit_pressed() -> void:
	get_tree().quit()

func _unhandled_key_input(event):
	if event.is_pressed():
		if $"MarginContainer/HBoxContainer/Buttons/Resume".has_focus() != true and $"MarginContainer/HBoxContainer/Buttons/Quit".has_focus() != true:
			$"MarginContainer/HBoxContainer/Buttons/Resume".grab_focus()

func _on_resume_mouse_entered() -> void:
	$"MarginContainer/HBoxContainer/Buttons/Resume".grab_focus()

func _on_resume_mouse_exited() -> void:
	$"MarginContainer/HBoxContainer/Buttons/Resume".release_focus()

func _on_quit_mouse_entered() -> void:
	$"MarginContainer/HBoxContainer/Buttons/Quit".grab_focus()

func _on_quit_mouse_exited() -> void:
	$"MarginContainer/HBoxContainer/Buttons/Quit".release_focus()
