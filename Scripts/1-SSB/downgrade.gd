extends Sprite2D

var initial_position
var gravity = 270
var rotation_velocity = 2200
var velocity = Vector2(0,-180)
var dispawn_distance = Vector2(0,200)

func _ready():
	initial_position = position
	dispawn_distance = initial_position + dispawn_distance

func _process(delta):
	position += velocity * delta
	velocity.y += gravity * delta
	rotation_degrees += rotation_velocity * delta
	if position > dispawn_distance:
		queue_free()
