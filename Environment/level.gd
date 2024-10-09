extends Node2D

# Number of food eaten
var score = 0;


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

# Called when the queen dies
func _on_queen_died() -> void:
	get_tree().change_scene_to_file("res://GameOver/game_over.tscn")


func _on_queen_food_collected() -> void:
	score += 1
	pass # Replace with function body.

