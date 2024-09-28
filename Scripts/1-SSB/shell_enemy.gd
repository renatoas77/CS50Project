extends CharacterBody2D

var is_shield_mode = false
var shield_mode_timer = 0.0
var shield_mode_duration = 5
var shield_mode_impulse = Vector2(800,0)
var shield_mode_velocity = Vector2.ZERO
var is_flipped = true
var gravity = 720.00
var ground_speed = Vector2(40,0)
var air_impulse = Vector2(80,-200)
var bounce_force = Vector2(0,-400)

func death_animation():
	velocity.y = -200
	$CollisionShape2D.set_deferred("disabled", true)

func get_hit(direction):
	if is_shield_mode and direction == Vector2.RIGHT:
		shield_mode_velocity = shield_mode_impulse 
		return
	elif is_shield_mode and direction == Vector2.LEFT:
		shield_mode_velocity = -shield_mode_impulse 
		return
	elif is_shield_mode:
		return
		
	if direction == Vector2.RIGHT:
		velocity = air_impulse
		velocity.y *= Global.gravity_scale
	elif direction == Vector2.LEFT:
		velocity = air_impulse * Vector2(-1,1) 
		velocity.y *= Global.gravity_scale
	move_and_slide()
	$AnimatedSprite2D.stop()

func check_shield_mode(delta):
	if shield_mode_velocity.x != 0:
		velocity = shield_mode_velocity
		return 
		
	if shield_mode_timer > 0:
		shield_mode_timer -= delta
	else:
		is_shield_mode = false
		$HitBox.monitoring = true

func flip():
	if velocity.x == 0 and not is_shield_mode:
		ground_speed *= -1
		is_flipped = not is_flipped
	$AnimatedSprite2D.flip_h = is_flipped
	
func check_death():	
	if global_position.y > 500 or global_position.y < -500:
		Global.kills += 1
		Global.score += 2000
		queue_free()

func walk():
	if is_on_floor() and not is_shield_mode or is_on_ceiling() and not is_shield_mode:
		$AnimatedSprite2D.play("walking")
		velocity = ground_speed * Global.gravity_scale

func apply_forces(delta):
	velocity.y += gravity * delta * Global.gravity_scale
	move_and_slide()

func _physics_process(delta):
	if Global.gravity_scale == 1:
		rotation_degrees = 0
	else:
		rotation_degrees = 180
	check_shield_mode(delta)
	walk()
	apply_forces(delta)
	flip()
	check_death()	

func _on_hurt_box_body_entered(body):
	if body.has_method("activate_shoot"):
		body.velocity.y = bounce_force.y * Global.gravity_scale
		$AnimatedSprite2D.play("shield_mode")
		shield_mode_timer = shield_mode_duration
		is_shield_mode = true
		shield_mode_velocity = Vector2.ZERO
		velocity = Vector2.ZERO
		$Steped.play() 
		
func _on_hit_box_body_entered(body):
	if body.has_method("get_damage") and velocity.x != 0:
		body.get_damage()
	elif body.has_method("get_hit") and velocity.x != 0 and is_shield_mode:
		if velocity.x > 0:
			body.get_hit(Vector2.RIGHT)
		else:
			body.get_hit(Vector2.LEFT)
	elif is_shield_mode:
		shield_mode_velocity *= -1
	else:
		ground_speed *= -1
		is_flipped = not is_flipped

func _on_hit_box_area_entered(area):
	if area.get_parent().has_method("death_animation") and is_shield_mode and velocity.x != 0:
		area.get_parent().death_animation() 
