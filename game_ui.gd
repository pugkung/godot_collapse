extends Node2D

onready var score_label = $Label/score_label
onready var life_label = $Label2/life_label
onready var gameover_label = $gameover_label

func _ready():
	gameover_label.visible = false


func _on_Button_pressed():
	get_tree().change_scene("res://scenes/main_menu.tscn")


func _on_grid_update_life(new_life):
	life_label.text = String(new_life)


func _on_grid_update_score(new_score):
	score_label.text = String(new_score)


func _on_grid_show_gameover():
	gameover_label.visible = true
