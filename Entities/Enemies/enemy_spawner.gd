extends Node2D

@export var enemy_scene: PackedScene
@export var spawn_interval: float = 5.0
@export var max_wave_size: int = 3
@export var max_enemy_size: int = 50
@export var min_spawn_distance: float = 50.0

@onready var screen_size: Vector2 = get_viewport_rect().size
@onready var player: CharacterBody2D = %Player

func _ready():
	if not player:
		push_error("Player node not found!")
		return
	
	var timer = Timer.new()
	timer.connect("timeout", Callable(self, "_on_spawn_timer_timeout"))
	timer.set_wait_time(spawn_interval)
	timer.set_one_shot(false)
	add_child(timer)
	timer.start()

func _on_spawn_timer_timeout():
	spawn_wave()

func spawn_wave():
	var enemy_count = get_tree().get_nodes_in_group("Enemy").size()
	var wave_size = randi_range(1, max_wave_size)
	
	# skip wave if new wave size would exceed max enemy size
	if enemy_count + wave_size > max_enemy_size:
		return
	
	for i in range(wave_size):
		var spawn_position = get_spawn_position()
		# don't try to find another spawn position, just skip if invalid position
		if spawn_position != Vector2.ZERO:
			spawn_enemy(spawn_position)

func get_spawn_position() -> Vector2:
	var player_position = player.global_position
	var spawn_position = Vector2.ZERO
	var edge = randi() % 4
	
	match edge:
		0:  # Top
			spawn_position = Vector2(randf_range(0, screen_size.x), 0)
		1:  # Right
			spawn_position = Vector2(screen_size.x, randf_range(0, screen_size.y))
		2:  # Bottom
			spawn_position = Vector2(randf_range(0, screen_size.x), screen_size.y)
		3:  # Left
			spawn_position = Vector2(0, randf_range(0, screen_size.y))
	
	# spawn position is on the opposite side of where the player is located
	if (spawn_position - player_position).length() < screen_size.length() / 2:
		spawn_position = player_position + (spawn_position - player_position).normalized() * screen_size.length()
	
	# overlap check, might not be needed
	var existing_enemies = get_tree().get_nodes_in_group("Enemy")
	for enemy in existing_enemies:
		if spawn_position.distance_to(enemy.global_position) < min_spawn_distance:
			return Vector2.ZERO
	
	return spawn_position

func spawn_enemy(pos: Vector2):
	var enemy = enemy_scene.instantiate()
	enemy.global_position = pos
	#enemy.add_to_group("Enemy")
	# add as child to root
	get_parent().add_child(enemy)
