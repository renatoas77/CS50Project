extends Node2D

var next_level

func _ready():
	Global.level = 0
	next_level = preload("res://Scenes/02-AAAAAA/IntroSSSSSS.tscn") 

func _on_death_area_body_entered(body):
	if body.has_method("death"):
		body.death()


func _on_win_area_body_entered(body):
	if body.has_method("win_game"):
		$Music.stop()
		$WinMusic.play()
		body.win_game()


func _on_win_music_finished():
	get_tree().change_scene_to_packed(next_level)
