extends TextureProgressBar

@onready var player: Node = %Player

@export var offset: Vector2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.max_value = player.health.maxHealth


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var center = Vector2(size.x/2, size.y/2)
	
	self.position = player.position - center + offset
	
	self.value = player.health.health
