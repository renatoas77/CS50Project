extends CharacterBody2D

var gravity = 720.0

var is_flipped = true
var bounce_force = Vector2(0,-300)
var dead_parts:PackedScene = preload("res://Scenes/01-super_shotgun_bros/standard_dead_body.tscn")
var particles:PackedScene = preload("res://Scenes/particles.tscn")
var is_dead = false
var walk_speed = 70

func _physics_process(delta):
	velocity.y += gravity * delta * Global.gravity_scale
	if not is_dead:
		velocity.x = walk_speed
		$AnimatedSprite2D.play("walk")
		$AnimatedSprite2D.flip_h = is_flipped
	else:
		$AnimatedSprite2D.stop()
		velocity.x = 0
		
	if Global.gravity_scale == -1:
		$AnimatedSprite2D.flip_v = true
	else:
		$AnimatedSprite2D.flip_v = false
		
	move_and_slide()
	
	if position.y > 1080:
		queue_free()

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

func _on_hurt_box_body_entered(body):
	if body.has_method("activate_shoot"):
		body.velocity = bounce_force
		scale.y = 0.1
		set_collision_layer_value(1,false)
		set_collision_layer_value(2,true)
		$HurtBox.set_deferred("monitoring", false)
		$HurtBox.set_deferred("monitorable", false)
		$HitBox.set_deferred("monitoring", false)
		$HitBox.set_deferred("monitorable", false)
		$hurt.play()
		is_dead = true
	
	
func _on_hit_box_body_entered(body):
	if body.has_method("get_damage") and not is_dead:
		body.get_damage()
	else:
		walk_speed *= -1
		is_flipped = not is_flipped
	
