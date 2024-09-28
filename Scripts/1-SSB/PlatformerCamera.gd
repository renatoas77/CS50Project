extends Camera2D

var shake_intensity = 5.0
var shake_duration = 0.2
var camera_limit = 75
var camera_speed = 250
var camera_distance = 0.0

func shake(delta):
	if Global.caremaTimeElapsed < shake_duration:
		var x = randf_range(-shake_intensity, shake_intensity)
		var y = randf_range(-shake_intensity, shake_intensity)
		offset.x += x
		offset.y += y
		Global.caremaTimeElapsed += delta

func _ready():
	Global.caremaTimeElapsed = (shake_duration + 0.1)

func flash(delta):
	if Global.flash_time > 0:
		$Flash.visible = true
		Global.flash_time -= delta
	else:
		$Flash.visible = false
		
func _process(delta):
	if $"..".is_flipped_h and camera_distance > -camera_limit:
		camera_distance -= camera_speed * delta
	elif not $"..".is_flipped_h and camera_distance < camera_limit:
		camera_distance += camera_speed * delta
		
	global_position.x = $"..".global_position.x + camera_distance
	global_position.y = 0
	offset = Vector2.ZERO
	shake(delta)
	flash(delta)
