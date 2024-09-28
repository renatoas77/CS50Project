extends StaticBody2D

@onready var animation:AnimationPlayer = $AnimationPlayer
var is_empty = false 
var shell01:PackedScene = preload("res://Scenes/01-super_shotgun_bros/upgrade00.tscn")
var shell02:PackedScene = preload("res://Scenes/01-super_shotgun_bros/upgrade01.tscn")
var impulse = 40

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
	
	var shell
	if Global.player_level == 0:
		shell = shell01.instantiate()
	else:
		shell = shell02.instantiate()
		
	var spawn_position =  (direction * impulse)
	shell.position = spawn_position
	get_parent().call_deferred("add_child",shell)
	
	$WithShell.visible = false
	$WithoutShell.visible = true
	is_empty = true
