extends TextureProgressBar

@onready var queen: Node = %Queen

@export var offset: Vector2

@export var smoothing: float
var maxHealth: float

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	maxHealth = queen.health.maxHealth


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var center = Vector2(size.x/2, size.y/2)
	self.position = queen.position - center + offset
	
	var actualHeatlh = (queen.health.health / maxHealth) * 100
	
	self.value = lerp(self.value, actualHeatlh, smoothing)
