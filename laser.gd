extends Area2D

@export var speed = 600

signal death

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	global_position.y += -speed*delta

#Despans laser when it leaves the screen
func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()


func _on_body_entered(area):
	#Only works if an explicit class name is given
	if area is Enemy:
		#remove laser and enemy, and emit death signal
		area.queue_free()
		queue_free()
		death.emit()
