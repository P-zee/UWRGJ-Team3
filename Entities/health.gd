extends Node

@export var maxHealth : float:
	set(newMaxHealth):
		var percentage : float = health / maxHealth
		maxHealth = newMaxHealth
		health = maxHealth*percentage
	get():
		return maxHealth
	
var health : float

signal tookDamage(damage : float)
signal healed(damage : float)
signal died()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	health = maxHealth
	#print("test")
	#died.connect(dieMessage)
	#healed.connect(healMessage)

	
func takeDamage(damage : float) -> void:
	health -= damage
	tookDamage.emit(damage)
	if(health <= 0):
		died.emit()
		
func heal(damage: float) -> void:
	health = min(maxHealth, health + damage)
	healed.emit(damage)

#func dieMessage() -> void:
#	print("the player has died")
#func healMessage(damage: float)->void:
#	print("the player has been healed the following health")
#	print(damage)
	
#func _input(event: InputEvent) -> void:
#	if(event.is_action_pressed("ui_down")):
#		takeDamage(1)
#	elif(event.is_action_pressed("ui_up")):
#		heal(2)
