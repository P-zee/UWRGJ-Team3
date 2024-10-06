extends CharacterBody2D

signal tookDamage(damage : int)
signal healed(health : int)
signal died()

@onready var health: Node = $Health

const SPEED = 150.0


func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_accept"):
		print(health.health)


func _physics_process(delta: float) -> void:
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	#if direction:
	velocity = direction * SPEED
	#else:
	#	velocity = move_toward(velocity.x, 0, SPEED)

	move_and_slide()


func _on_health_died() -> void:
	died.emit()


func _on_health_healed(health: int) -> void:
	healed.emit(health)


func _on_health_took_damage(damage: int) -> void:
	tookDamage.emit(damage)
