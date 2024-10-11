extends CharacterBody2D

@export var max_speed: = 80.0
@export var min_speed: = 30.0
@export var target_force: = 8.0
@export var cohesion: = 2.0
@export var alignment: = 3.0
@export var separation: = 5.0
@export var view_distance: = 50.0
@export var avoid_distance: = 25
@export var max_flock_size: = 15
@export var screen_avoid_force: = 10.0
# min distance to start targeting the queen
@export var queen_target_distance: = 100.0 
# min distance to ignore the player
@export var player_ignore_distance: = 200.0

var animationDirection : String = "Down"

@export var enemy_damage = 1.0
@onready var animatedSprite: AnimatedSprite2D = $AnimatedSprite2D

@export var food_drop_chance: float = 0.5
@export var food_scene: PackedScene

@onready var screen_size: Vector2 = get_viewport_rect().size
var player: CharacterBody2D
var queen: CharacterBody2D

signal died()
signal healed(damage: float)
signal tookDamage(damage: float)

var target: Vector2
var flock = []
var flock_size: int = 0

var gettingHit : bool = false

func _ready():
	player = get_tree().current_scene.get_node("%Player")
	queen = get_tree().current_scene.get_node("%Queen")
	if not player:
		push_error("Player not found!")
	if not queen:
		push_error("Queen not found!")
	$flock_sensor/sensor_shape.shape.radius = view_distance
	randomize()
	velocity = Vector2(randf_range(-1, 1), randf_range(-1, 1)).normalized() * max_speed


func _on_flock_sensor_body_entered(body):
	if self != body and body.is_in_group("Enemy"):
		flock.append(body)
		flock_size = flock.size()
		
func _on_flock_sensor_body_exited(body):
	if self != body and body.is_in_group("Enemy"):
		flock.remove_at(flock.find(body))
		flock_size = flock.size()

func _physics_process(_delta):
	update_target()
	
	#var screen_avoid_vector = Vector2.ZERO
	#screen_avoid_vector = avoid_screen_edge() * screen_avoid_force

	var vectors = process_flock()
	
	var cohesion_vector = vectors[0] * cohesion
	var align_vector = vectors[1] * alignment
	var separation_vector = vectors[2] * separation

	var acceleration = align_vector + cohesion_vector + separation_vector
	var target_vector = global_position.direction_to(target)
	acceleration += target_vector * target_force
	
	velocity = (velocity + acceleration).limit_length(max_speed)
	if velocity.length() <= min_speed:
		velocity = (velocity * min_speed).limit_length(max_speed)
	updateDirection(velocity.normalized())
	if(!gettingHit):
		animatedSprite.play("Walk"+animationDirection)
		move_and_slide()
	$MeleeHitbox.rotation = Vector2.RIGHT.angle_to(target_vector)

func update_target():
	var distance_to_queen = global_position.distance_to(queen.global_position)
	var distance_to_player = global_position.distance_to(player.global_position)
	
	if distance_to_queen <= queen_target_distance and distance_to_player >= player_ignore_distance:
		target = queen.global_position
	else:
		target = player.global_position

func updateDirection(direction : Vector2) -> void:
	if(direction == Vector2.ZERO):
		return
	if(abs(direction.x)<.75):
		if(direction.y<0):
			animationDirection = "Up"
		else:
			animationDirection = "Down"
	else:
		if(direction.x > 0):
			animationDirection = "Right"
		else:
			animationDirection = "Left"

func process_flock():
	var cohesion_vector: = Vector2()
	var flock_center: = Vector2()
	var align_vector: = Vector2()
	var seperation_vector: = Vector2()
	
	for other in flock:
		var other_pos: Vector2 = other.global_position
		var other_velocity: Vector2 = other.velocity

		if global_position.distance_to(other_pos) < view_distance:
			align_vector += other_velocity
			flock_center += other_pos
	
			var d = global_position.distance_to(other_pos)
			if d < avoid_distance:
				seperation_vector -= other_pos - global_position

	if flock_size > 0:
		align_vector /= flock_size
		flock_center /= flock_size
		cohesion_vector = global_position.direction_to(flock_center)

	return [cohesion_vector.normalized(),
			align_vector.normalized(), 
			seperation_vector.normalized()]

func get_random_target():
	randomize()
	return Vector2(randf_range(0, screen_size.x), randf_range(0, screen_size.y))


func avoid_screen_edge():
	var edge_avoid_vector: = Vector2.ZERO
	if position.x - avoid_distance < 0:
		edge_avoid_vector.x = 1
	elif position.x + avoid_distance > screen_size.x:
		edge_avoid_vector.x = -1
	if position.y - avoid_distance < 0:
		edge_avoid_vector.y = 1
	elif position.y + avoid_distance > screen_size.y:
		edge_avoid_vector.y = -1
	
	return edge_avoid_vector.normalized()

func wrap_screen():
	position.x = wrapf(position.x, 0, screen_size.x)
	position.y = wrapf(position.y, 0, screen_size.y)

func take_player_damage(damage: float):
	$Health.takeDamage(damage)
	gettingHit=true
	animatedSprite.play("Hit"+animationDirection)
	animatedSprite.animation_finished.connect(hitDone)

func hitDone():
	animatedSprite.animation_finished.disconnect(hitDone)
	gettingHit=false
	animatedSprite.play("Walk"+animationDirection)

# Damages any bodies that have the method take_enemy_damage
# This is almost identical to the method in player.gd
func swing_melee(damage: float):
	# First, make sure melee swing is off of cooldown
	if $MeleeCooldown.is_stopped():
		$MeleeCooldown.start()
		# Here, put logic for swing animation
		# Now, get all enemies in the melee hitbox
		for body in $MeleeHitbox.get_overlapping_bodies():
			# If this body has a method called take_enemy_damage, then
			#  call it with the amount of damage to deal.
			if "take_enemy_damage" in body:
				# Deal damage to the body we hit
				body.take_enemy_damage(damage)

# Tests whether this enemy can hit something
func target_in_range() -> bool:
	var in_range = false
	for body in $MeleeHitbox.get_overlapping_bodies():
		# If this body has a method called take_enemy_damage, then
		#  call it with the amount of damage to deal.
		if "take_enemy_damage" in body:
			in_range = true
	return in_range

func _on_health_died() -> void:
	if randf() < food_drop_chance and food_scene:
		var dropped_entity = food_scene.instantiate()
		get_parent().add_child(dropped_entity)
		dropped_entity.global_position = global_position
	died.emit()
	queue_free()

func _on_health_healed(damage: float) -> void:
	healed.emit(damage)

func _on_health_took_damage(damage: float) -> void:
	tookDamage.emit(damage)

# When a body comes within swinging range, try to hit it.
func _on_melee_hitbox_body_entered(body: Node2D) -> void:
	swing_melee(enemy_damage)

# Once the cooldown is up, test if this enemy can hit something again.
# This makes the enemy keep swinging at something as long as it's in range.
func _on_melee_cooldown_timeout() -> void:
	if target_in_range():
		swing_melee(enemy_damage)
