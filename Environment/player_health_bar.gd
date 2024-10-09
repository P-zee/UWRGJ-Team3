extends TextureProgressBar

@onready var player: Node = %Player

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.max_value = player.health.maxHealth


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	self.value = player.health.health
