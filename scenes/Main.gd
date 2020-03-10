extends Node2D

const THRUST = 500
const MAX_SPEED = 500
const TOP_LEVEL = 14
const TEST_STRUCT = false
const TEST_ENEMY = true
const TEST_TARGET_INDEX = 17

var background : ParallaxBackground
var sky: GSky
var terrain : Terrain
var anim : AnimationPlayer
var player : Player
var map : Map
var ui : UI
var scroll_position
var speed = 0
var enemy_scene = preload("res://scenes/Enemy.tscn")
var missile_scene = preload("res://scenes/Missile.tscn")
var player_scene = preload("res://scenes/Player.tscn")
var sky_pos = 0
var enemies_to_spawn = 10
var size
var stats : Statistics

func _ready():
	globals.game = self
	background = $ParallaxBackground
	sky = find_node("Sky")
	anim = $AnimationPlayer
	map = $Map
	stats = $Statistics
	ui = $UI
	# Allow for renaming of the parallax layer(s) later, so using find_node() and get_parent()
	terrain = find_node("Terrain")
	terrain.get_parent().motion_mirroring.x = terrain.last_point.x
	# Start in the middle of the map
	scroll_position = terrain.last_point.x / 2
	# warning-ignore:return_value_discarded
	get_tree().get_root().connect("size_changed", self, "resize")
	resize()
	map.set_points(terrain)
	for node in $States.get_children():
		node.g = self
	ui.pop_up_with_text()


func resize():
	size = get_viewport_rect().size
	terrain.set_base_level(size)
	sky.resize(size)
	map.resize(terrain, size.y)
	map.rect_position.x = (size.x - map.rect_size.x) / 2
	stats.rect_size.x = size.x
	ui.rect_position = (size - ui.rect_size) / 2


func add_player():
	player = player_scene.instance()
	globals.player = player
	player.position = Vector2(player.MARGIN, size.y / 2)
	map.add_player(player, scroll_position, terrain)
	add_child(player)


func add_structures():
	# Add to terrain flats
	var nodes = terrain.get_nodes_for_structures(Structures.DENSITY)
	for node in nodes:
		var structure = Structures.generate()
		node.add_child(structure)
		structure.add_to_group(structure.tag)
		map.add_entity(structure)
	if TEST_STRUCT:
		add_test_structure()


func add_test_structure():
	# Test falling
	var structure = Structures.generate()
	structure.position = Vector2(scroll_position + 50, -80)
	structure.state = 1
	terrain.line.add_child(structure) # Usually add to a Flat


func spawn_enemy():
	if enemies_to_spawn:
		var target = pick_target()
		if target:
			add_enemy(target)
			enemies_to_spawn -= 1
			if !TEST_ENEMY:
				$Spawner.start(rand_range(1, 5))


func _on_Spawner_timeout():
	spawn_enemy()


func pick_target():
	var targets = []
	# Get all untargeted structures
	for node in get_tree().get_nodes_in_group("building"):
		if !node.targeted:
			targets.append(node)
	for node in get_tree().get_nodes_in_group("energy_source"):
		if !node.targeted:
			targets.append(node)
	var pick = false
	if targets.size():
		var i = randi() % targets.size()
		if TEST_ENEMY:
			i = TEST_TARGET_INDEX # Manually choose a target
		pick = targets[i]
	pick.targeted = true
	return pick


func add_enemy(target):
	var enemy = enemy_scene.instance()
	enemy.target = { "object": target, "position": target.get_parent().position }
	enemy.position = Vector2(enemy.target.position.x + rand_range(-100, 100), -size.y)
	enemy.connect("enemy_killed", stats, "add_points")
	terrain.line.add_child(enemy)
	globals.add_entity(enemy, "enemies")
	map.add_entity(enemy)


func fire_missile():
	var m = missile_scene.instance()
	terrain.add_child(m)
	m.start(terrain, scroll_position, speed, terrain.last_point.x)
	player.get_node("Fire").play()


func move_background(delta):
	scroll_position = wrapf(scroll_position + delta , 0, terrain.last_point.x)
	background.scroll_offset.x = scroll_position
	sky_pos += delta
	sky.set_offset(sky_pos)
