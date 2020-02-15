extends ColorRect

class_name Map

const DX = 2.0
const SCALE = DX / 8
const ITEM_SCALE = Vector2(SCALE, SCALE)

var coor_scale : Vector2
var line: Line2D
var structures
var enemies
var player
var plane

func _ready():
	line = $Line2D
	structures = $Structures
	enemies = $Enemies


func set_points(terrain: Terrain):
	line.clear_points()
	for i in terrain.line.get_point_count():
		line.add_point(terrain.line.points[i] * coor_scale)


func resize(terrain: Terrain, y_size):
	coor_scale = self.rect_size / Vector2(terrain.line.get_point_count() * terrain.GRID_SIZE, y_size)
	line.position = Vector2(0, terrain.base_level * coor_scale.y)
	set_points(terrain)


func add_structures():
	for s in globals.structures.values():
		var node = s.duplicate()
		node.get_child(0).queue_free()
		node.name = str(s.get_instance_id())
		node.scale = ITEM_SCALE
		structures.add_child(node)


func add_enemy(e):
	var node = e.get_node("Sprite").duplicate()
	node.name = str(e.get_instance_id())
	node.scale = ITEM_SCALE
	enemies.add_child(node)


func update_entities(entities, scroll_position):
	for e in get(entities).get_children():
		var id = int(e.name)
		if globals.get(entities).keys().has(id):
			var node = globals.get(entities)[id]
			e.position = get_node_position(node, scroll_position)
			e.modulate = node.modulate
		else:
			e.queue_free()


func update_all_entities(scroll_position):
	update_entities("structures", scroll_position)
	update_entities("enemies", scroll_position)


func get_node_position(node, offset):
	return node.global_position * coor_scale - Vector2(DX - rect_size.x  + offset * coor_scale.x, DX)


func add_player(p, scroll_position, terrain): 
	player = p.duplicate()
	player.get_child(0).queue_free()
	position_player(p, scroll_position, terrain)
	add_child(player)
	plane = player.get_node("Sprite")


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
	plane.flip_h = !plane.flip_h


func _process(_delta):
	pass
