extends Node2D

var vanish_timer = 0.0
var time_to_vanish
var particles = preload("res://Scenes/coin_particles.tscn")

func _ready():
	$RigidBody2D/Node2D/AnimationPlayer.stop()
	$RigidBody2D/AudioStreamPlayer2D.pitch_scale = randf_range(0.9,1.1)
	time_to_vanish = randf_range(0.1,2.5)
	await get_tree().create_timer(time_to_vanish).timeout
	$RigidBody2D/Node2D/AnimationPlayer.play("vanish")

func call_particles():
	var particle = particles.instantiate()
	get_parent().add_child(particle)
	particle.global_position = $RigidBody2D.global_position

func play_sound():
	$RigidBody2D/AudioStreamPlayer2D.play()

func _on_audio_stream_player_2d_finished():
	Global.score += 50
	queue_free()

func apply_impulse(impulse:Vector2):
	get_child(0).apply_impulse(impulse)
	
func _physics_process(_delta):
	get_child(0).gravity_scale = Global.gravity_scale
