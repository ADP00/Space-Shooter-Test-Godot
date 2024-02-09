extends Node

@export var mob_scene: PackedScene
var score

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

#executed when hit signal from player is emitted
func game_over():
	$MobTimer.stop()
	
	$HUD.show_game_over()
	
	#Play death animation when player dies
	$DeathAnimation.position = $Player.position
	$DeathAnimation.visible = true
	$DeathAnimation.play()	

#connected to start_game signal from hud
func new_game():
	score = 0
	$Player.start($StartPosition.position)
	$StartTimer.start()
	
	$HUD.update_score(score)
	$HUD.show_message("Mission Start")
	
	get_tree().call_group("mobs", "queue_free")


func _on_start_timer_timeout():
	$MobTimer.start()


func _on_mob_timer_timeout():
	var mob = mob_scene.instantiate()
	
	var mob_spawn_location = $MobPath/MobSpawnLocations
	mob_spawn_location.progress_ratio = randf()
	
	var direction = mob_spawn_location.rotation + PI/2
	
	mob.position = mob_spawn_location.position
	
	var velocity = Vector2(randf_range(50.0, 80.0), 0.0)
	mob.linear_velocity = velocity.rotated(direction)
	
	add_child(mob)


func _on_death_animation_animation_finished():
	$DeathAnimation.stop()
	$DeathAnimation.visible = false
