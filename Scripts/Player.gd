extends CharacterBody2D

var player_speed = 36000

func _physics_process(delta):
	velocity.y = 0
	if Input.is_action_pressed("left"):
		velocity.x = -player_speed * delta
	elif Input.is_action_pressed("right"):
		velocity.x = player_speed * delta
	else:
		velocity.x = 0
	position.y = 410
	move_and_slide()

func _on_field_players_points():
	position = Vector2(0,400)
