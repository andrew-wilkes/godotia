extends ColorRect

class_name Map

signal end_of_level

const SCALE = 0.25
const ITEM_SCALE = Vector2(SCALE, SCALE)

var coor_scale : Vector2
var line: Line2D
var structures
var enemies
var player

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
	# Don't care about the position here
	for s in globals.structures.values():
		var node = s.get_node("Sprite").duplicate()
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
		if globals.get(entities)[id].visible:
			var node = globals.get(entities)[id]
			e.position = get_node_position(node, scroll_position)
			e.modulate = node.modulate
		else:
			e.queue_free()
			globals.get(entities)[id].queue_free()
			globals.get(entities).erase(id)


func update_all_entities(scroll_position = 0):
	update_entities("structures", scroll_position)
	update_entities("enemies", scroll_position)
	if enemies.get_child_count() < 1:
		emit_signal("end_of_level")


func get_node_position(node, offset):
	return node.global_position * coor_scale + Vector2(rect_size.x - offset * coor_scale.x, 0)


func add_player(p, scroll_position, terrain): 
	player = p.get_node("Sprite").duplicate()
	position_player(p, scroll_position, terrain)
	add_child(player)


func position_player(p, scroll_position, terrain):
	player.scale = ITEM_SCALE * 0.5
	var max_x = terrain.last_point.x
	var x = wrapf(max_x - scroll_position + p.position.x, 0, max_x)
	player.position = Vector2(x, p.position.y) * coor_scale


func turn_player():
	player.flip_h = !player.flip_h
