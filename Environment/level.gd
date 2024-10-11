extends Node2D

# Number of food eaten
var max_score = 20
var score = max_score;
@onready var score_display: RichTextLabel = $UI/ScoreDisplay

# Number of food needed to win
const SCORE_TO_WIN = 20;
#@onready var score_display: RichTextLabel = $UI/ScoreDisplay

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if(score_display != null):
		#score_display.add_text(str(score))
		score_display.text= "[center]"+str(score)+"[/center]"
	
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

# Called when the queen dies
func _on_queen_died() -> void:
	get_tree().change_scene_to_file("res://GameOver/gameover.tscn")


func _on_queen_food_collected() -> void:
	#print(score_display==null)
	score -= 1
	if(score_display != null):
		#score_display.add_text(str(score))
		score_display.text= "[center]"+str(score)+"[/center]"
	#print(score)
	# Check if the score is enough for a win
	if (score <= 0):
		get_tree().change_scene_to_file("res://GameOver/gamewin.tscn")
	


func _on_player_died() -> void:
	score = score + 1
	if score > max_score:
		score = max_score
	if(score_display != null):
		#score_display.add_text(str(score))
		score_display.text= "[center]"+str(score)+"[/center]"
