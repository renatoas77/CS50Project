extends Area2D

var particles = preload("res://Scenes/particles.tscn")
var dead_parts = preload("res://Scenes/01-super_shotgun_bros/jumping_dead_body.tscn")
var origin_point = 0.0
var velocity = 0.0
var jump_impulse = -400
var custom_gravity = 720.00
var jump_timer = 0
var time_to_jump = 1.5

func get_hit(direction):
	var particle:CPUParticles2D = particles.instantiate()
	particle.emitting = true
	particle.lifetime = 0.2
	particle.position = global_position
	get_parent().add_child(particle)
	var dead_body = dead_parts.instantiate()
	dead_body.position = global_position
	dead_body.direction = direction
	Global.kills += 1
	Global.score += 300
	get_parent().call_deferred("add_child",dead_body)
	call_deferred("queue_free")

func jump():
	if jump_timer > time_to_jump:
		velocity = jump_impulse 
	
func apply_gravity(delta):
	if global_position < origin_point:
		velocity += custom_gravity * delta
	else:
		velocity = 0
		
func my_timer(delta):
	if global_position >= origin_point:
		jump_timer += delta
	else:
		jump_timer = 0

func _ready():
	$AnimatedSprite2D.play()
	origin_point = global_position

func _physics_process(delta):
	global_position.y += velocity * delta
	my_timer(delta)
	apply_gravity(delta)
	jump()

func _on_body_entered(body):
	if body.has_method("get_damage"):
		body.get_damage()
