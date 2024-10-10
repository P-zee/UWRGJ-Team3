extends TextureProgressBar

var parent = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	parent = get_parent()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	self.value = parent.health.health
	self.max_value = parent.health.maxHealth
