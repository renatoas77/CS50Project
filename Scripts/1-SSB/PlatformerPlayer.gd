extends CharacterBody2D

var downgrades1 = preload("res://Scenes/01-super_shotgun_bros/downgrade1.tscn")
var downgrades2 = preload("res://Scenes/01-super_shotgun_bros/downgrade2.tscn")
var shoots: PackedScene
var shoot01 = preload("res://Scenes/01-super_shotgun_bros/shoot_area01.tscn")
var shoot02 = preload("res://Scenes/01-super_shotgun_bros/shoot_area02.tscn")
var shoot03 = preload("res://Scenes/01-super_shotgun_bros/shoot_area03.tscn")
var sounds: Array
var shoot_power = 200
var power_upgrade = 100
var is_controle_on = true
var animation_lock_timer = 0.0
var shotgun_shoot_time =  0.5
var deceleration = 400.0
var acceleration = 600.0
var max_speed = 200.0
var jump_force = -360.0
var gravity = 720.0
var run_right_time = 0.0
var run_left_time = 0.0
var double_tap_time = 0.150
var is_flipped_h = false
var is_flipped_v = false
var shoot_flash_time = 0.1
var shoot_distance = 40
var current_animation: AnimatedSprite2D
var current_sound: AudioStreamPlayer2D
var animations: Array
var death_hop =  Vector2(0,-240)
var jump_buffer = 0.0
var buffer_time = 0.3
var is_jump_buffered:bool
var coyote_time = 0.2
var timer_coyote = 0.0
var is_coyote_time:bool
var gravity_shift_on = false

func _ready():
	if Global.level == 1:
		gravity_shift_on = true
	Global.gravity_scale = 1
	Global.player_level = 0
	is_flipped_h = false
	animations.append($Level1)
	animations.append($Level2)
	animations.append($Level3)
	sounds.append($shotgun01)
	sounds.append($shotgun02)
	sounds.append($shotgun03)
	current_sound = sounds[0]
	current_animation = animations[0]
	shoots = shoot01

func shift_gravity():
	if is_coyote_time and Input.is_action_just_pressed("shift") and gravity_shift_on:
		Global.gravity_scale *= -1
		is_flipped_v = not is_flipped_v
		current_animation.flip_v = is_flipped_v
		is_coyote_time = false
		coyote_time = 0.0
		$GravityShift.play()

func death():
	$losing.play()
	is_controle_on = false
	$CollisionBox.set_deferred("disabled",true)
	await get_tree().create_timer(3,true,false,false).timeout
	Global.death()
	get_tree().reload_current_scene()
	
func win_game():
	is_controle_on = false
	velocity.x = 0
	current_animation.flip_h = false
	current_animation.animation = "walk"
	current_animation.stop()
	await get_tree().create_timer(1).timeout
	$AnimationPlayer.play("WinAnimation")
	
func upgrade():
	if Global.player_level >= 2:
		return
	
	if Global.player_level == 0:
		Global.score += 500
		shoot_distance += 20
		shoots = shoot02
	else:
		shoots = shoot03
		Global.score += 3000
	
	$powerUp.play()
	current_animation.visible = false
	Global.player_level += 1
	current_animation = animations[Global.player_level]
	current_sound = sounds[Global.player_level]
	current_animation.visible = true
	current_animation.flip_h = is_flipped_h
	current_animation.flip_v = is_flipped_v
	current_animation.animation = "transformation"
	current_animation.play()
	animation_lock_timer = 1
	shoot_power += power_upgrade
	
func get_damage():
	Global.HitStop(0.5)
	velocity.y = death_hop.y
	if Global.player_level == 0:
		death()
		return
	
	current_animation.visible = false
	if Global.player_level == 2:
		var downgrade = downgrades2.instantiate()
		downgrade.position = global_position
		get_parent().add_child(downgrade)
		shoots = shoot02
	elif Global.player_level == 1:
		var downgrade = downgrades1.instantiate()
		downgrade.position = global_position
		get_parent().add_child(downgrade)
		shoot_distance -= 20
		shoots = shoot01
	$hurt.play()
	Global.player_level -= 1
	current_animation = animations[Global.player_level]
	current_sound = sounds[Global.player_level]
	current_animation.visible = true
	current_animation.flip_h = is_flipped_h
	current_animation.flip_v = is_flipped_v
	shoot_power -= power_upgrade
		
func buffer_jump(delta):
	if jump_buffer > 0.0:
		jump_buffer -= delta
	else:
		is_jump_buffered = false
	
	if Input.is_action_just_pressed("Space"):
		jump_buffer = buffer_time
		is_jump_buffered = true
		
func get_coyote_time(delta):
	if is_on_floor() and Global.gravity_scale > 0:
		timer_coyote = coyote_time
		is_coyote_time = true
		return
	elif is_on_ceiling() and Global.gravity_scale < 0:
		timer_coyote = coyote_time
		is_coyote_time = true
		return
	
	if timer_coyote > 0:
		timer_coyote -= delta
	else:
		is_coyote_time = false
		return
		
func apply_deceleration(delta):	
	if velocity.x > 0:
		if velocity.x - (deceleration * delta) > 0:
			velocity.x -= deceleration * delta
		else:
			velocity.x = 0
	elif velocity.x < 0:
		if velocity.x + (deceleration * delta) < 0:
			velocity.x += deceleration  * delta
		else:
			velocity.x = 0
		
func instantiate_shoot(direction:Vector2):
	var shoot = shoots.instantiate() as Area2D
	if direction == Vector2.UP:
		shoot.rotation_degrees = 270
	elif direction == Vector2.DOWN:
		shoot.rotation_degrees = 90
	elif direction == Vector2.LEFT:
		shoot.rotation_degrees = 180
	shoot.direction = direction
	shoot.position = get_parent().global_position + (direction * shoot_distance)
	add_child(shoot)
	
func activate_shoot():
	current_sound.pitch_scale = randf_range(0.8,1.2)
	if Input.is_action_just_pressed("shoot") and Input.is_action_pressed("Up"):
		if Global.gravity_scale == 1:
			current_animation.animation = "shoot_up"
		else:
			current_animation.animation = "shoot_down"
		current_sound.play()
		instantiate_shoot(Vector2.UP)
		velocity.y += shoot_power
		animation_lock_timer = shotgun_shoot_time
		Global.ShakeCamera()
		Global.flash_time = shoot_flash_time
	elif Input.is_action_just_pressed("shoot") and Input.is_action_pressed("Down"):
		if Global.gravity_scale == 1:
			current_animation.animation = "shoot_down"
		else:
			current_animation.animation = "shoot_up"
		current_sound.play()
		instantiate_shoot(Vector2.DOWN)
		velocity.y -= shoot_power
		animation_lock_timer = shotgun_shoot_time
		Global.ShakeCamera()
		Global.flash_time = shoot_flash_time
	elif Input.is_action_just_pressed("shoot"):
		current_animation.animation = "shoot"
		current_sound.play()
		if is_flipped_h:
			instantiate_shoot(Vector2.LEFT)
			velocity.x +=  shoot_power
		else:
			instantiate_shoot(Vector2.RIGHT)
			velocity.x -= shoot_power
		animation_lock_timer = shotgun_shoot_time
		Global.ShakeCamera()
		Global.flash_time = shoot_flash_time
		
func jump():
	if is_jump_buffered and is_coyote_time:
		velocity.y = jump_force * Global.gravity_scale
		jump_buffer = 0.0
		timer_coyote = 0.0
		$jump.play()
	
	if not is_on_floor() and not is_on_ceiling():
		if velocity.y < 0 and Global.gravity_scale == 1:
			current_animation.animation = "jump"
		elif velocity.y > 0 and Global.gravity_scale == 1:
			current_animation.animation = "fall"
		elif velocity.y > 0 and Global.gravity_scale != 1:
			current_animation.animation = "jump"
		elif velocity.y < 0 and Global.gravity_scale != 1:
			current_animation.animation = "fall"
		
func move_player(delta):
	if Input.is_action_pressed("right") and run_right_time > 0:
		run_right_time = double_tap_time
		is_flipped_h = false
		current_animation.flip_h = is_flipped_h
		current_animation.animation = "running"
		current_animation.play()
		if  velocity.x + (acceleration * delta) < max_speed * 2:
			velocity.x += acceleration * delta
		else:
			velocity.x = max_speed * 2
	elif Input.is_action_pressed("right"):
		is_flipped_h = false
		current_animation.flip_h = is_flipped_h
		current_animation.animation = "walk"
		current_animation.play()
		if  velocity.x + (acceleration * delta) < max_speed:
			velocity.x += acceleration * delta
		else:
			velocity.x = max_speed
	elif Input.is_action_pressed("left") and run_left_time > 0:
		run_left_time = double_tap_time
		is_flipped_h = true
		current_animation.flip_h = is_flipped_h
		current_animation.animation = "running"
		current_animation.play()
		if  velocity.x - (acceleration * delta) > -max_speed * 2:
			velocity.x += acceleration * delta * -1
		else:
			velocity.x = max_speed * -1	* 2
	elif Input.is_action_pressed("left"):
		is_flipped_h = true
		current_animation.flip_h = is_flipped_h
		current_animation.animation = "walk"
		current_animation.play()
		if  velocity.x - (acceleration * delta) > -max_speed:
			velocity.x += acceleration * delta * -1
		else:
			velocity.x = max_speed * -1
	else:
		current_animation.animation = "walk"
		current_animation.stop()
	
	if Input.is_action_just_released("left"):
		run_left_time = double_tap_time
	elif Input.is_action_just_released("right"):
		run_right_time = double_tap_time
	
	if run_left_time > 0:
		run_left_time -= delta
		
	if run_right_time > 0:
		run_right_time -= delta
		
func apply_forces(delta):
	move_and_slide()
	apply_deceleration(delta)
	velocity.y += gravity * delta * Global.gravity_scale

func _physics_process(delta):
	apply_forces(delta)
	buffer_jump(delta)
	get_coyote_time(delta)
	shift_gravity()
	if is_controle_on:
		if animation_lock_timer > 0:
			animation_lock_timer -= delta
		else:
			move_player(delta)
			jump()
			activate_shoot()
