extends Area2D

@export var speed = 400 #pixels/second
var screen_size

#preload laser scene
var laser_scene = preload("res://laser.tscn")
#laser cool down
var laser_cool_down = false
@export var laser_rate = 0.2

#Adds signal for collisions
signal hit

#Signal for laser
signal laser_shot(location)

# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size
	
	#Player hidden at start
	hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#Set Movement
	var velocity = Vector2.ZERO
	if Input.is_action_pressed("move_right"):
		velocity.x += 1
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1
	if Input.is_action_pressed("move_down"):
		velocity.y += 1
	if Input.is_action_pressed("move_up"):
		velocity.y -= 1
	
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
	
	#Set Animation
	$AnimatedSprite2D.play()
	if velocity.x > 0:
		$AnimatedSprite2D.animation = "right"
	elif velocity.x < 0:
		$AnimatedSprite2D.animation = "left"
	else:
		$AnimatedSprite2D.animation = "idle"
	
	#Keeps player in bounds of window
	position += velocity * delta
	position = position.clamp(Vector2.ZERO, screen_size)
	
	#Check for shoot input
	if Input.is_action_pressed("shoot"):
		if !laser_cool_down:
			#Another input will not trigger if statement
			laser_cool_down = true
			shoot()
			#cool down by waiting
			await get_tree().create_timer(laser_rate).timeout
			#allow to if to be accessed again
			laser_cool_down = false


func _on_body_entered(body):
	hide()
	hit.emit()
	$CollisionShape2D.set_deferred("disabled", true)

#Set position and show the player
func start(pos):
	position = pos
	show()
	$CollisionShape2D.disabled = false

#Emit shoot signal with start point
func shoot():
	#global position must be sent, not position
	laser_shot.emit($LaserStart.global_position)
