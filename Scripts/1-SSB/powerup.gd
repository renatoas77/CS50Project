extends Node2D

func _on_area_2d_body_entered(body):
	if body.has_method("upgrade"):
		body.upgrade()
		call_deferred("queue_free")

func _physics_process(_delta):
	get_child(0).gravity_scale = Global.gravity_scale
