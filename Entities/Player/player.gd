extends CharacterBody2D

signal tookDamage(damage : float)
signal healed(health : float)
signal died()

@onready var health: Node = $Health

var gettingHit: bool = false
var attacking : bool = false
var respawning : bool = false
@onready var animatedSprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var queen: CharacterBody2D = %Queen
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D

const SPEED = 150.0

@export var baseMaxHealth:float = 20

@export var melee_damage = 5.0

var animationDirection : String = "Down"

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("fire_melee"):
		swing_melee(melee_damage)


func _physics_process(_delta: float) -> void:
	# Face towards the mouse
	$MeleeHitbox.look_at(get_global_mouse_position())
	#print((queen.position-position).length())
	health.maxHealth=min(baseMaxHealth,baseMaxHealth*100/(queen.position-position).length())
	
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_vector("move_left", "move_right", "move_up", "move_down")
	#print(direction)
	#if direction:
	if(!respawning && (queen.position-position).length()>700):
		_on_health_died()
	
	if(respawning):
		updateDirection((queen.position-position).normalized())
		velocity = (queen.position-position).normalized() * SPEED*2
		animatedSprite.play("Shelless"+animationDirection)
		#animatedSprite.play("WalkDown")
		#print("Shelless"+animationDirection)
		move_and_slide()
		if((queen.position-position).length()<70):
			health.heal(baseMaxHealth)
			collision_shape_2d.disabled=false
			respawning=false
		return
	
	
	velocity = direction * SPEED
	move_and_slide()
	if(!attacking):
		if(!gettingHit):
			animatedSprite.play("Walk" + animationDirection)
		updateDirection(direction)
	
	#else:
	#	velocity = move_toward(velocity.x, 0, SPEED)



func _on_health_died() -> void:
	died.emit()
	respawning=true
	collision_shape_2d.disabled=true
	%AudioManager.play_fx("DM-CGS-43")
	

func updateDirection(direction : Vector2) -> void:
	if(direction == Vector2.ZERO):
		return
	if(abs(direction.x)<.75):
		if(direction.y<0):
			animationDirection = "Up"
		else:
			animationDirection = "Down"
	else:
		if(direction.x>0):
			animationDirection = "Right"
		else:
			animationDirection = "Left"
	#print(animationDirection)

func _on_health_healed(damage: float) -> void:
	healed.emit(damage)


func _on_health_took_damage(damage: float) -> void:
	tookDamage.emit(damage)
	#print("took some damage")


func take_enemy_damage(damage: float):
	$Health.takeDamage(damage)
	%AudioManager.play_fx("DM-CGS-05")
	if(!respawning && !gettingHit):
		animatedSprite.play("Hit" + animationDirection)
		animatedSprite.animation_finished.connect(hitFinished)
		gettingHit=true

func attackFinished():
	animatedSprite.animation_finished.disconnect(attackFinished)
	animatedSprite.play("Walk" + animationDirection)
	attacking=false
	
func hitFinished():
	gettingHit=false
	animatedSprite.play("Walk" + animationDirection)
	#print("hit finished")
	animatedSprite.animation_finished.disconnect(hitFinished)


# Damages any bodies that have the method take_player_damage
func swing_melee(damage: float):
	# First, make sure melee swing is off of cooldown
	if $MeleeCooldown.is_stopped() && !respawning:
		$MeleeCooldown.start()
		animatedSprite.animation_finished.connect(attackFinished)
		#updateDirection((get_global_mouse_position() - position).normalized())
		animatedSprite.play("Attack" + animationDirection)
		%AudioManager.play_fx("DM-CGS-22")
		attacking=true
		#print("Attack"+animationDirection)
		# Here, put logic for swing animation
		# Now, get all enemies in the melee hitbox
		for body in $MeleeHitbox.get_overlapping_bodies():
			# If this body has a method called take_player_damage, then
			#  call it with the amount of damage to deal.
			if "take_player_damage" in body:
				# Deal damage to the body we hit
				body.take_player_damage(damage)
