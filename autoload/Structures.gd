extends Node2D

const TEST = true

func generate():
	return get_child(randi() % get_child_count()) as Structure


func _ready():
	if TEST:
		for _i in range(8):
			print(generate().title)
	else:
		visible = false
