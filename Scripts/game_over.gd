extends Node2D

var intro = load("res://Scenes/Intro.tscn")

func restart():
	get_tree().change_scene_to_packed(intro)
	
# Called when the node enters the scene tree for the first time.
func _ready():
	Global.lifes = 3
	Global.score = 0
	
func _process(_delta):
	if Input.is_anything_pressed():
		restart()

func _on_timer_timeout():
	restart()
