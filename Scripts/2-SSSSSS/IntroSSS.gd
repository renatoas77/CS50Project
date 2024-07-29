extends Node2D

var next_scene = preload("res://Scenes/02-AAAAAA/ssssss.tscn")

func _ready():
	Global.level = 1

func _on_timer_timeout():
	get_tree().change_scene_to_packed(next_scene)
