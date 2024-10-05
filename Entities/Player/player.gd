extends CharacterBody2D


const SPEED = 150.0


func _physics_process(delta: float) -> void:


	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	#if direction:
	velocity = direction * SPEED
	#else:
	#	velocity = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
