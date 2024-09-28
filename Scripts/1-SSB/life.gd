extends Node2D

func _on_area_2d_body_entered(body):
	if body.has_method("upgrade"):
		Global.lifes += 1
		call_deferred("queue_free")
