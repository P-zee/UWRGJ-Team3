extends TextureProgressBar

@onready var player: Node = %Player
@export var offset: Vector2
@export var smoothing: float
@export var max_width: float = 120.0

var test_decrement = 120.0

var maxHealth: float

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	maxHealth = player.health.maxHealth


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var center = Vector2(size.x/2, size.y/2)
	self.position = player.position - center + offset
	
	var actualHeatlh = (player.health.health / maxHealth) * 100
	
	# The percent the player's max health is currently, out of the highest it could be.
	self.size.x = (player.health.maxHealth / player.baseMaxHealth) * max_width
	
	self.value = lerp(self.value, actualHeatlh, smoothing)
