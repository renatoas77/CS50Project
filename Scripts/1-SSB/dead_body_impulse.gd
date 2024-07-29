extends Node2D

var direction = Vector2.ZERO
var impulse_force = 600
var impulse_variation = 75
var variation = Vector2.ZERO

func _ready():
	for child in get_children():
		if child.has_method("apply_impulse"):
			variation = Vector2(randf_range(-impulse_variation,impulse_variation),randf_range(impulse_variation,impulse_variation))
			child.apply_impulse((direction * impulse_force + variation))


func _on_timer_timeout():
	queue_free()

func _physics_process(_delta):
	for child in get_children():
		if child.has_method("apply_impulse"):
			child.gravity_scale = Global.gravity_scale
