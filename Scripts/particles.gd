extends CPUParticles2D

var elapsed_time = 0
var duration = 1

func _ready():
	emitting = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if elapsed_time < duration:
		elapsed_time += delta
	else:
		queue_free()
