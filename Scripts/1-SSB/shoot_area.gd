extends Area2D

var direction:Vector2

func _ready():
	var animation = $shot
	animation.play()
	
	
func _on_body_entered(body):
	if body.has_method("get_hit"):
		body.get_hit(direction)
		Global.HitStop(0.15)


func _on_animated_sprite_2d_animation_finished():
	call_deferred("queue_free")


func _on_area_entered(area):
	_on_body_entered(area)
