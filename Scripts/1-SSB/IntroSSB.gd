extends Node2D

var next_scene = preload("res://Scenes/01-super_shotgun_bros/ssb.tscn")

func _on_timer_timeout():
	Global.level = 0
	get_tree().change_scene_to_packed(next_scene)
