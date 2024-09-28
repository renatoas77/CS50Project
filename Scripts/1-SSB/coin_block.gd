extends StaticBody2D

@onready var animation:AnimationPlayer = $AnimationPlayer
var is_empty = false 
var coins:PackedScene = preload("res://Scenes/01-super_shotgun_bros/coin.tscn")
var impulse = 40
var variance_rate = 50
var impulse_force = 600

func get_hit(direction):
	if direction == Vector2.UP:
		animation.play("up")
	elif direction == Vector2.DOWN:
		animation.play("down")
	elif direction == Vector2.RIGHT:
		animation.play("right")
	else:	
		animation.play("left")
	
	if is_empty:
		return
	
	for n in 10:
		Global.score += 20
		var coin = coins.instantiate()
		var spawn_position =  (direction * impulse)
		coin.position = spawn_position
		var variance = Vector2(randf_range(-variance_rate,variance_rate),randf_range(-variance_rate,variance_rate))
		coin.apply_impulse((impulse_force * direction) + variance)
		get_parent().call_deferred("add_child",coin)
	
	$WithShell.visible = false
	$WithoutShell.visible = true
	is_empty = true
