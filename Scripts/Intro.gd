extends Node

var pong_opening = preload("res://Scenes/01-super_shotgun_bros/IntroSSB.tscn")

func _process(_delta):
		if Input.is_action_just_pressed("Space"):
			get_tree().change_scene_to_packed(pong_opening)
