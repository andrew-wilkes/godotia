extends Node2D

class_name Terrain

const SEED = 7
const GRID_SIZE = 16.0
const MIN_NUM_POINTS = 5000
const MAX_HEIGHT = 300

var line
var base_level
var flats = []
var last_point

func _ready():
	line = $Line2D
	set_base_level()
# warning-ignore:return_value_discarded
	get_tree().get_root().connect("size_changed", self, "set_base_level")
	add_points()


func set_base_level():
	base_level = get_viewport_rect().size.y - GRID_SIZE
	line.position.y = base_level


func add_points():
	var rng = RandomNumberGenerator.new()
	rng.set_seed(SEED)
	var pos = Vector2(0, 0)
	add_point(pos)
	while pos.x < MIN_NUM_POINTS or abs(pos.y) > 0:
		pos.x += GRID_SIZE
		pos.y += (rng.randi() % 3 - 1) * GRID_SIZE # -1, 0, 1 * GRID_SIZE
		pos.y = clamp(pos.y, -MAX_HEIGHT, 0)
		add_point(pos)
	print("End pos: %d Flats: %d" % [pos.x, flats.size()])


func add_point(p):
	var point = Vector2(p.x, p.y)
	line.add_point(point)
	# Save points of the flat sections of terrain
	if last_point and last_point.y == point.y:
		flats.append(point)
	last_point = point


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
