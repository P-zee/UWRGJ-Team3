extends CharacterBody2D


# Crab's speed
@export var speed : float  = 30
# If the crab is currently running after a piece of food
var targetState : int =0 #0=targetting food, 1 = targetting player, 2 = moving randomly
# If the crab is currently collecting a piece of food
var collectingFood : bool = false
# If the crab is getting hit
var gettingHit : bool = false
# Position the crab wants to go
var goalPosition : Vector2 = Vector2.ZERO
# Random walk size
var randomRange : float = 100
# Dictate distance threshold for the crab to reach the goal destination
var collectRange : float = 10
var updateWalkRange : float = 2
# Animation
@onready var animatedSprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var player: CharacterBody2D = %Player
@onready var health: Node = $Health

signal died()
signal healed(damage: int)
signal tookDamage(damage: int)

func _ready() -> void:
	getGoalPosition()

func queenDied():
	died.emit()

func _physics_process(delta: float) -> void:
	if(targetState==0):
		if(position.distance_to(goalPosition)<collectRange):
			animatedSprite.play("Collect Food")
			animatedSprite.animation_finished.connect(collectFood)
			collectingFood=true
	elif(targetState==1):
		getGoalPosition()
	else:
		if(position.distance_to(goalPosition)<updateWalkRange):
			getGoalPosition()
	if(!collectingFood && goalPosition != position && !gettingHit):
		position+=(goalPosition-position).normalized() * delta * speed
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

func hit(damage: int) -> void:
	if(collectingFood):
		return
	animatedSprite.play("Hit")
	animatedSprite.animation_finished.connect(hitDone)
	gettingHit=true
	tookDamage.emit(damage)

func hitDone() -> void:
	animatedSprite.play("Walk")
	animatedSprite.animation_finished.disconnect(hitDone)
	gettingHit=false


func getGoalPosition() -> void:
	# Go to Food
	if(false):
		targetState = 0
	# Go to Player
	elif(player!=null):
		goalPosition=player.position
		targetState=1
	# Pick Random Direction
	else:
		var randomPoint : Vector2 = position + Vector2(randf_range(-randomRange,randomRange), randf_range(-randomRange,randomRange))
		# ENFORCE MAP BOUNDARY CONDITIONS
		targetState = 2
		goalPosition = randomPoint
	
	rotation=(Vector2.UP).angle_to(goalPosition-position)


func _on_health_healed(damage: int) -> void:
	healed.emit(damage)
