extends ParallaxBackground

@export var speed = 100.0
@export var direction = Vector2.DOWN

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	scroll_base_offset += (speed*direction)*delta
