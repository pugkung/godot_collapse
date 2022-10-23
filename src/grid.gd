extends Node2D

export (int) var width
export (int) var height
export (int) var x_start
export (int) var y_start
export (int) var offset

var pieces_list = [
	preload("res://scenes/red_piece.tscn"),
	preload("res://scenes/green_piece.tscn"),
	preload("res://scenes/blue_piece.tscn"),
	preload("res://scenes/yellow_piece.tscn"),
	preload("res://scenes/white_piece.tscn")
]

var all_pieces = []

var touch_pos = Vector2(0,0)

func _ready():
	all_pieces = make_2d_array()
	spawn_pieces()


func make_2d_array():
	var array = []
	for i in width:
		array.append([])
		for j in height:
			array[i].append(null)
	return array


func spawn_pieces():
	for i in width:
		for j in height:
			var rand = floor(rand_range(0, pieces_list.size()))
			var piece = pieces_list[rand].instance()
			add_child(piece)
			piece.position = grid_to_pixel(i,j)


func grid_to_pixel(col, row):
	var new_x = x_start + offset * col
	var new_y = y_start + -offset * row
	return Vector2(new_x, new_y)


func pixel_to_grid(pos_x, pos_y):
	var new_x = round(abs((pos_x - x_start + 32) / offset))
	var new_y = round(abs((pos_y - y_start + 32) / -offset))
	return Vector2(new_x, new_y)


func is_in_grid(col, row):
	if col >= 0 && col < width:
		if row >= 0 && row < height:
			return true
	return false


func touch_input():
	if Input.is_action_just_pressed("ui_touch"):
		touch_pos = get_global_mouse_position()
		var grid_pos = pixel_to_grid(touch_pos.x, touch_pos.y)
		if is_in_grid(grid_pos.x, grid_pos.y):
			print(grid_pos)
	pass


func _process(delta):
	touch_input()
