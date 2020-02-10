extends ColorRect

class_name Map

const DX = 2.0
const SCALE = DX / 8
const ITEM_SCALE = Vector2(SCALE, SCALE)

var coor_scale : Vector2
var line: Line2D
var structures = {}

func _ready():
	line = $Line2D


func set_points(terrain: Terrain):
	line.clear_points()
	for i in terrain.line.get_point_count():
		line.add_point(terrain.line.points[i] * coor_scale)


func resize(terrain: Terrain, y_size):
	coor_scale = self.rect_size / Vector2(terrain.line.get_point_count() * terrain.GRID_SIZE, y_size)
	line.position = Vector2(0, terrain.base_level * coor_scale.y)
	set_points(terrain)


func add_structures(grid_size):
	for s in get_tree().get_nodes_in_group("structures"):
		var node = s.duplicate()
		node.scale = ITEM_SCALE
		node.position *= coor_scale
		node.position -= Vector2(DX, DX)
		line.add_child(node)
		structures[s.get_instance_id()] = node
	pass



func _process(delta):
	pass
