extends Node2D

const TEST = false
const DENSITY = 0.3

func generate():
	var item = get_child(randi() % get_child_count()).duplicate()
	item.position = Vector2(0, 0)
	return item 


func _ready():
	if TEST:
		for _i in range(8):
			print(generate().title)
	else:
		visible = false
		position.y = -999 # Prevent unwanted collisions with the autoloaded nodes
