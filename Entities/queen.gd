extends CharacterBody2D


# Crab's speed
@export var speed : float  = 30
# If the crab is currently running after a piece of food
var targetingFood : bool = false
# If the crab is currently collecting a piece of food
var collectingFood : bool = false
# Position the crab wants to go
var goalPosition : Vector2 = Vector2.ZERO
# Random walk size
var randomRange : float = 100
# Dictate distance threshold for the crab to reach the goal destination
var collectRange : float = 10
var updateWalkRange : float = 2
# Animation
@onready var animatedSprite: AnimatedSprite2D = $AnimatedSprite2D


func _ready() -> void:
	getGoalPosition()


func _physics_process(delta: float) -> void:
	if(targetingFood):
		if(position.distance_to(goalPosition)<collectRange):
			animatedSprite.play("Collect Food")
			animatedSprite.animation_finished.connect(collectFood)
			collectingFood=true
	else:
		if(position.distance_to(goalPosition)<updateWalkRange):
			getGoalPosition()
	if(!collectingFood):
		transform.origin+=(goalPosition-position).normalized() * delta * speed
	#print("test")
	
	move_and_slide()

func collectFood() -> void:
	getGoalPosition()
	animatedSprite.play("Walk")
	animatedSprite.animation_finished.disconnect(collectFood)
	collectingFood=false
	# Destroy Food
	# Add Score
	# Whatever Else


func getGoalPosition() -> void:
	# Go to Food
	if(false):
		pass
	# Go to Player
	elif(false):
		pass
	# Pick Random Direction
	else:
		var randomPoint : Vector2 = position + Vector2(randf_range(-randomRange,randomRange), randf_range(-randomRange,randomRange))
		# ENFORCE MAP BOUNDARY CONDITIONS
		goalPosition = randomPoint
	
	rotation=(Vector2.UP).angle_to(goalPosition-position)
