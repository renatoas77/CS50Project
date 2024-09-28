extends CharacterBody2D

var particles = preload("res://Scenes/particles.tscn")
var dead_parts = preload("res://Scenes/01-super_shotgun_bros/spike_dead_body.tscn")
var gravity = 720.0
var is_flipped = true
var walk_speed = 2400



func get_hit(direction):
	var particle:CPUParticles2D = particles.instantiate()
	particle.emitting = true
	particle.lifetime = 0.2
	particle.position = global_position
	get_parent().add_child(particle)
	var dead_body = dead_parts.instantiate()
	dead_body.position = global_position
	dead_body.direction = direction
	Global.score += 300
	Global.kills += 1
	get_parent().call_deferred("add_child",dead_body)
	call_deferred("queue_free")

func _ready():
	$AnimatedSprite2D.play()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	velocity.y += gravity * delta * Global.gravity_scale
	velocity.x = walk_speed * delta
	move_and_slide()
	if position.y > 500 or position.y < -500:
		queue_free()
		
	if Global.gravity_scale == -1:
		$AnimatedSprite2D.flip_v = true
	else:
		$AnimatedSprite2D.flip_v = false
		

func _on_area_2d_body_entered(body):
	if body.has_method("get_damage"):
		body.get_damage()
	else:
		walk_speed *= -1
		is_flipped = not is_flipped
		$AnimatedSprite2D.flip_h = is_flipped
