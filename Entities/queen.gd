extends CharacterBody2D


# Crab's speed
@export var speed : float  = 50
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
var collectRange : float = 50
var updateWalkRange : float = 2
# Animation
@onready var animatedSprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var player: CharacterBody2D = %Player
@onready var health: Node = $Health
var currentFood : Node = null

signal died()
signal healed(damage: int)
signal tookDamage(damage: int)
signal foodCollected()

func _ready() -> void:
	getGoalPosition()

func queenDied():
	died.emit()

func _physics_process(delta: float) -> void:
	if(targetState==0):
		if(currentFood==null):
			getGoalPosition()
			
		elif(position.distance_to(goalPosition)<collectRange && !collectingFood):
			animatedSprite.play("Collect Food")
			#print("hi")
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
	#getGoalPosition()
	animatedSprite.animation_finished.disconnect(collectFood)
	animatedSprite.play("Walk")
	collectingFood=false
	currentFood.queue_free() 
	currentFood=null
	targetState=2
	getGoalPosition()
	%AudioManager.play_fx("DM-CGS-21")
	%AudioManager.play_fx("DM-CGS-48")
	#print("co")
	foodCollected.emit()
	# Whatever Else

func hit(damage: int) -> void:
	if(collectingFood):
		return
	tookDamage.emit(damage)
	%AudioManager.play_fx("DM-CGS-49")
	if(!gettingHit):
		animatedSprite.animation_finished.connect(hitDone)
		animatedSprite.play("Hit")
		gettingHit=true

func hitDone() -> void:
	animatedSprite.play("Walk")
	animatedSprite.animation_finished.disconnect(hitDone)
	gettingHit=false


func getGoalPosition() -> void:
	# Go to Food
	#print()
	var foodNode=null
	for N in $"..".get_children():
		if N.name.substr(0,4) == "Food" or N.name.substr(0,5) == "@Node":
			foodNode=N
			break
		#else:
			#print(N.name)
	
	if(foodNode!= null):
		targetState = 0
		currentFood=foodNode
		goalPosition=currentFood.position
		#print(currentFood)
	# Go to Player
	elif(false && player!=null):
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


func take_player_damage(damage: float):
	$Health.takeDamage(damage)

func take_enemy_damage(damage: float):
	$Health.takeDamage(damage)
