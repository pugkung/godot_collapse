extends Node2D

export (String) var color
var move_tween


func _ready():
	move_tween = get_node("move_tween")


func move(target):
	print(position)
	print(target)
	move_tween.interpolate_property(self, "position", position, target, .2,
									Tween.TRANS_CUBIC, Tween.EASE_OUT)
	move_tween.start()
