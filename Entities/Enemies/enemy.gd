extends CharacterBody2D

@export var max_speed: = 50.0
@export var min_speed: = 30.0
@export var target_force: = 8.0
@export var cohesion: = 2.0
@export var alignment: = 3.0
@export var separation: = 5.0
@export var view_distance: = 50.0
@export var avoid_distance: = 25
@export var max_flock_size: = 15
@export var screen_avoid_force: = 10.0

@onready var screen_size: Vector2 = get_viewport_rect().size

@onready var player: CharacterBody2D = %Player

var target: Vector2
var flock = []
var flock_size: int = 0

func _ready():
	$flock_sensor/sensor_shape.shape.radius = view_distance
	randomize()
	velocity = Vector2(randf_range(-1, 1), randf_range(-1, 1)).normalized() * max_speed

func _on_flock_sensor_body_entered(body):
	if self != body and body.is_in_group("Boid"):
		flock.append(body)
		flock_size = flock.size()
		
func _on_flock_sensor_body_exited(body):
	flock.remove_at(flock.find(body))
	flock_size = flock.size()

func _physics_process(_delta):
	if player:
		target = player.global_position
	
	var screen_avoid_vector = Vector2.ZERO
	screen_avoid_vector = avoid_screen_edge() * screen_avoid_force

	var vectors = process_flock()
	
	var cohesion_vector = vectors[0] * cohesion
	var align_vector = vectors[1] * alignment
	var separation_vector = vectors[2] * separation

	var acceleration = align_vector + cohesion_vector + separation_vector + screen_avoid_vector
	var target_vector = global_position.direction_to(target)
	acceleration += target_vector * target_force
	
	velocity = (velocity + acceleration).limit_length(max_speed)
	if velocity.length() <= min_speed:
		velocity = (velocity * min_speed).limit_length(max_speed)
		
	move_and_slide()

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
	
