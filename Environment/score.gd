extends RichTextLabel

@onready var level: Node2D = $"../.."

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	self.text = "[center]" + str(level.score) + "[/center]"
