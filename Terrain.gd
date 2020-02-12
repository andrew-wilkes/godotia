extends Node2D

class_name Terrain

const SEED = 7
const GRID_SIZE = 16.0
const MAX_X_TARGET = 5000
const MAX_HEIGHT = 300

var line
var base_level
var flats = []
var last_point
var flat: Resource

func _ready():
	line = $Line2D
	flat = load("res://Flat.tscn")
	# Set width of flat collision segment resource
	flat.instance().get_child(0).shape.set_a(Vector2(-GRID_SIZE, 0))
	add_points()


func set_base_level(y_size):
	base_level = y_size - GRID_SIZE
	line.position.y = base_level


func _add_point(point: Vector2):
	line.add_point(point)
	# Save points of the flat sections of terrain
	if last_point and last_point.y == point.y:
		flats.append(point)
		var f = flat.instance()
		f.position = point
		line.add_child(f)
	last_point = point


func add_points():
	var rng = RandomNumberGenerator.new()
	rng.set_seed(SEED)
	var pos = Vector2(0, 0)
	_add_point(pos)
	while pos.x < MAX_X_TARGET or abs(pos.y) > 0:
		pos.x += GRID_SIZE
		pos.y += (rng.randi() % 3 - 1) * GRID_SIZE # -1, 0, 1 * GRID_SIZE
		pos.y = clamp(pos.y, -MAX_HEIGHT, 0)
		_add_point(pos)
	print("End pos: %d Flats: %d" % [pos.x, flats.size()])


func get_points_for_structures(density: float):
	var points = []
	var last_y = null
	for i in range(flats.size()):
		var point = flats[i]
		# Avoid adjacent structures
		if point.y != last_y:
			# Consider placing a structure at this point
			if randf() <= density:
				points.append(point)
				last_y = point.y
				continue
		last_y = null
	return points
