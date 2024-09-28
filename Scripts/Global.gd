extends Node

var level = 0
var player_level = 0
var end_game = preload("res://Scenes/GameOver.tscn")
var lifes:int = 3
var flash_time = 0.0
var caremaTimeElapsed = 0.0
var score = 0
var kills = 0
var gravity_scale = 1

func ShakeCamera():
	caremaTimeElapsed = 0

func death():
	lifes -= 1
	if lifes < 1:
		get_tree().call_deferred("change_scene_to_packed",end_game)
		
func HitStop(time:float):
	Engine.time_scale = 0.1
	await get_tree().create_timer(time,false,false,true).timeout
	Engine.time_scale = 1
