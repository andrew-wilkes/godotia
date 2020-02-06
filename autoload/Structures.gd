extends Node2D

const TEST = true
const DENSITY = 0.3

var coors = []

func generate():
	return get_child(randi() % get_child_count()).duplicate() as Structure


func _ready():
	if TEST:
		for _i in range(8):
			print(generate().title)
	else:
		visible = false


func get_item(point: Vector2, grid_size: float):
	var item = generate()
	item.position = point - Vector2(grid_size, grid_size)
	return item
