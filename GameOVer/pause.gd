extends Control

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
