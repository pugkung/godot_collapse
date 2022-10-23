extends Node2D

export (int) var width
export (int) var height
export (int) var x_start
export (int) var y_start
export (int) var offset
export (int) var y_offset

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
	randomize()
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
			var piece = gen_new_piece()
			add_child(piece)
			piece.position = grid_to_pixel(i,j)
			all_pieces[i][j] = piece


func gen_new_piece():
	var rand = floor(rand_range(0, pieces_list.size()))
	var new_piece = pieces_list[rand].instance()
	return new_piece

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
			var grid_list = get_neighbour_matches(grid_pos.x, grid_pos.y)
			if len(grid_list) >= 2:
				destroy_pieces(grid_list)
	pass


func get_neighbour_matches(i,j):
	var matched_list = []
	var color = all_pieces[i][j].color
	traverse(matched_list, i, j, color)
	return matched_list


func traverse(matched_list, i, j, color):
	if (i >= width or i < 0 or j >= height or j < 0 or
		Vector2(i,j) in matched_list):
		return matched_list
		
	if not Vector2(i,j) in matched_list:
		matched_list.append(Vector2(i,j))
		
	if i+1 < width and color == all_pieces[i+1][j].color:
		traverse(matched_list, i+1, j, color)	# right
	if i-1 >= 0 and color == all_pieces[i-1][j].color:
		traverse(matched_list, i-1, j, color)	# left
	if j+1 < height and color == all_pieces[i][j+1].color:
		traverse(matched_list, i, j+1, color)	# up
	if j-1 >= 0 and color == all_pieces[i][j-1].color:
		traverse(matched_list, i, j-1, color)	# down


func _process(delta):
	touch_input()


func destroy_pieces(destroy_list):
	for pos in destroy_list:
		print(pos)
		if all_pieces[pos.x][pos.y] != null:
			all_pieces[pos.x][pos.y].queue_free()
			all_pieces[pos.x][pos.y] = null
	collapse_columns()


func collapse_columns():
	for i in width:
		for j in height:
			if all_pieces[i][j] == null:
				for k in range(j+1, height):
					if all_pieces[i][k] != null:
						all_pieces[i][k].move(grid_to_pixel(i,j))
						all_pieces[i][j] = all_pieces[i][k]
						all_pieces[i][k] = null
						break
	refill_columns()


func refill_columns():
	for i in width:
		for j in height:
			if all_pieces[i][j] == null:
				var piece = gen_new_piece()
				add_child(piece)
				piece.position = grid_to_pixel(i,j - y_offset)
				piece.move(grid_to_pixel(i,j))
				all_pieces[i][j] = piece;
