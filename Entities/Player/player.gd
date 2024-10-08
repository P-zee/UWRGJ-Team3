extends CharacterBody2D

signal tookDamage(damage : float)
signal healed(health : float)
signal died()

@onready var health: Node = $Health

const SPEED = 150.0

@export var melee_damage = 5.0


func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("fire_melee"):
		swing_melee(melee_damage)


func _physics_process(_delta: float) -> void:
	# Face towards the mouse
	look_at(get_global_mouse_position())
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_vector("move_left", "move_right", "move_up", "move_down")
	#if direction:
	velocity = direction * SPEED
	#else:
	#	velocity = move_toward(velocity.x, 0, SPEED)

	move_and_slide()


func _on_health_died() -> void:
	died.emit()


func _on_health_healed(damage: float) -> void:
	healed.emit(damage)


func _on_health_took_damage(damage: float) -> void:
	tookDamage.emit(damage)

# Damages any bodies that have the method take_player_damage
func swing_melee(damage: float):
	# First, make sure melee swing is off of cooldown
	if $MeleeCooldown.is_stopped():
		$MeleeCooldown.start()
		# Here, put logic for swing animation
		print("Swing!")
		# Now, get all enemies in the melee hitbox
		for body in $MeleeHitbox.get_overlapping_bodies():
			# If this body has a method called take_player_damage, then
			#  call it with the amount of damage to deal.
			if "take_player_damage" in body:
				# Deal damage to the body we hit
				body.take_player_damage(damage)
				print(body.to_string() + " has taken " + str(damage) + " damage.")
