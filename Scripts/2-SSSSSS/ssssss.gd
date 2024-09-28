extends Node2D

var next_level = preload("res://Scenes/CS50Ending.tscn")

func _on_area_2d_body_entered(body):
	if body.has_method("win_game"):
		$Music.stop()
		$WinMusic.play()
		body.win_game()


func _on_upper_death_area_body_entered(body):
	if body.has_method("win_game"):
		body.death()
	elif body.has_method("get_hit"):
		body.get_hit(Vector2.ZERO)


func _on_lower_death_area_body_entered(body):
	if body.has_method("win_game"):
		body.death()
	elif body.has_method("get_hit"):
		body.get_hit(Vector2.ZERO)


func _on_win_music_finished():
	get_tree().change_scene_to_packed(next_level)
