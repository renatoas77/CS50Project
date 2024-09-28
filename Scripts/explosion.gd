extends AudioStreamPlayer2D

func _ready():
	$".".pitch_scale = randf_range(0.9,1.1)

func _on_finished():
	call_deferred("queue_free")
