extends ColorRect

class_name Map

signal end_of_level

const SCALE = 0.25
const ITEM_SCALE = Vector2(SCALE, SCALE)

var coor_scale : Vector2
var line: Line2D
var entities
var player
var nodes = []
var new_nodes = []

func _ready():
	line = $Line2D
	entities = $Entities


func set_points(terrain: Terrain):
	line.clear_points()
	for i in terrain.line.get_point_count():
		line.add_point(terrain.line.points[i] * coor_scale)


func resize(terrain: Terrain, y_size):
	coor_scale = self.rect_size / Vector2(terrain.line.get_point_count() * terrain.GRID_SIZE, y_size)
	line.position = Vector2(0, terrain.base_level * coor_scale.y)
	set_points(terrain)


func add_entity(e):
	# Don't care about the position here
	var node = e.get_node("Sprite").duplicate()
	node.name = get_id(e)
	node.scale = ITEM_SCALE
	entities.add_child(node)
	nodes.append(node.name)


func remove_entities():
	for e in entities.get_children():
		e.queue_free()


func update_entities(e_array, scroll_position):
	for e in e_array:
		var map_node = entities.get_child(nodes.find(get_id(e)))
		# Record the existing entity id
		new_nodes.append(get_id(e))
		map_node.position = get_node_position(e, scroll_position)
		map_node.modulate = e.modulate


func get_id(node):
	return str(node.get_instance_id())


func update_all_entities(scroll_position = 0):
	new_nodes = []
	update_entities(get_tree().get_nodes_in_group("building"), scroll_position)
	update_entities(get_tree().get_nodes_in_group("energy_source"), scroll_position)
	var enemies = get_tree().get_nodes_in_group("enemies")
	update_entities(enemies, scroll_position)
	nodes = new_nodes
	clean_entities()
	if enemies.size() < 1:
		emit_signal("end_of_level")


func clean_entities():
	for node in entities.get_children():
		if !nodes.has(node.name):
			node.queue_free()


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
