extends ColorRect

class_name Map

const DX = 2.0
const SCALE = DX / 8
const ITEM_SCALE = Vector2(SCALE, SCALE)

var coor_scale : Vector2
var line: Line2D
var structures = {}
var player

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


func add_structures():
	for s in get_tree().get_nodes_in_group("structures"):
		var node = s.duplicate()
		node.scale = ITEM_SCALE
		node.position *= coor_scale
		node.position -= Vector2(DX, DX)
		line.add_child(node)


func add_player(p, scroll_position, terrain): 
	player = p.duplicate()
	position_player(p, scroll_position, terrain)
	add_child(player)


func position_player(p, scroll_position: int, terrain):
	var max_x = terrain.last_point.x
	player.scale = ITEM_SCALE
	var x = max_x - scroll_position + p.position.x
	if x > max_x:
		x = x - max_x
	if x < 0:
		x = max_x - x
	player.position = Vector2(x, p.position.y) * coor_scale


func turn_player():
	player.flip_h = !player.flip_h


func _process(_delta):
	pass
