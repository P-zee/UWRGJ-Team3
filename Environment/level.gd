extends Node2D

# Number of food eaten
var score = 0;

# Number of food needed to win
const SCORE_TO_WIN = 5;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

# Called when the queen dies
func _on_queen_died() -> void:
	get_tree().change_scene_to_file("res://GameOver/gameover.tscn")


func _on_queen_food_collected() -> void:
	score += 1
	# Check if the score is enough for a win
	if (score >= SCORE_TO_WIN):
		get_tree().change_scene_to_file("res://GameOver/gameover.tscn")
	
