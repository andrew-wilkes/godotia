extends Node2D

class_name Terrain

const SEED = 7
const GRID_SIZE = 16.0
const MAX_X_TARGET = 5000
const MAX_HEIGHT = 300

var line
var ground
var base_level
var flats = []
var last_point
var flat: Resource

func _ready():
	line = $Line2D
	flat = load("res://scenes/Flat.tscn")
	# Set width of flat collision segment resource
	flat.instance().get_child(0).shape.set_a(Vector2(-GRID_SIZE, 0))
	add_collision_surfaces()


func set_base_level(size):
	base_level = size.y - GRID_SIZE
	line.position.y = base_level


func add_collision_surfaces():
	var rng = RandomNumberGenerator.new()
	rng.set_seed(SEED)
	var pos = Vector2(0, 0)
	add_collision_surface(pos)
	while pos.x < MAX_X_TARGET or abs(pos.y) > 0:
		pos.x += GRID_SIZE
		pos.y += (rng.randi() % 3 - 1) * GRID_SIZE # -1, 0, 1 * GRID_SIZE
		pos.y = clamp(pos.y, -MAX_HEIGHT, 0)
		add_collision_surface(pos)
	print("End pos: %d Flats: %d" % [pos.x, flats.size()])


func add_collision_surface(point: Vector2):
	line.add_point(point)
	# Save points of the flat sections of terrain
	if last_point and last_point.y == point.y:
		var f = flat.instance()
		f.position = point
		flats.append(f)
		line.add_child(f)
	last_point = point


func get_nodes_for_structures(density: float):
	var nodes = []
	var last_y = null
	for i in range(flats.size()):
		var point = flats[i].position
		# Avoid adjacent structures
		if point.y != last_y:
			# Consider placing a structure at this point
			if randf() <= density:
				nodes.append(flats[i])
				last_y = point.y
				continue
		last_y = null
	return nodes
