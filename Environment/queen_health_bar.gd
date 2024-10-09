extends TextureProgressBar

@onready var queen: Node = %Queen

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.max_value = queen.health.maxHealth


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	self.value = queen.health.health
