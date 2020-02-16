extends Node2D

const TEST = false
const DENSITY = 0.3

var coors = []

func generate():
	return get_child(randi() % get_child_count()).duplicate()


func _ready():
	if TEST:
		for _i in range(8):
			print(generate().title)
	else:
		visible = false


func get_item(point: Vector2):
	var item = generate()
	item.position = point
	return item
