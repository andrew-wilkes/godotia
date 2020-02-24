extends Node2D

const THRUST = 500
const MAX_SPEED = 500
const TOP_LEVEL = 14
const TEST_STRUCT = false
const TEST_ENEMY = true
const TEST_TARGET_INDEX = 17

enum { LEFT, RIGHT }

var background : ParallaxBackground
var sky: GSky
var terrain : Terrain
var anim : AnimationPlayer
var player
var map: Map
var scroll_position
var speed = 0
var enemy_scene = preload("res://scenes/Enemy.tscn")
var missile_scene = preload("res://scenes/Missile.tscn")
var sky_pos = 0
var enemies_to_spawn = 0
var size
var stats

func _ready():
	background = $ParallaxBackground
	sky = find_node("Sky")
	player = $Player
	globals.player = player
	player.direction = RIGHT
	anim = $AnimationPlayer
	map = $Map
	stats = $Statistics
	# Allow for renaming of the parallax layer(s) later, so using find_node() and get_parent()
	terrain = find_node("Terrain")
	terrain.get_parent().motion_mirroring.x = terrain.last_point.x
	# Start in the middle of the map
	scroll_position = terrain.last_point.x / 2
	# warning-ignore:return_value_discarded
	get_tree().get_root().connect("size_changed", self, "resize")
	resize()
	map.set_points(terrain)
	start_game()


func resize():
	size = get_viewport_rect().size
	terrain.set_base_level(size)
	sky.resize(size)
	map.resize(terrain, size.y)
	map.rect_position.x = (size.x - map.rect_size.x) / 2
	stats.rect_size.x = size.x


func start_game():
	player.position.x = player.MARGIN
	# Add structures to terrain flats
	var nodes = terrain.get_nodes_for_structures(Structures.DENSITY)
	for node in nodes:
		var structure = Structures.generate()
		globals.add_entity(structure, "structures")
		node.add_child(structure)
	map.add_structures()
	map.add_player(player, scroll_position, terrain)
	enemies_to_spawn = 10
	spawn_enemy()
	stats.reset()
	if TEST_STRUCT:
		add_test_structure()


func stop_game():
	stats.stop_clock()


func add_test_structure():
	# Test falling
	var structure = Structures.generate()
	structure.position = Vector2(scroll_position + 50, -80)
	structure.state = 1
	terrain.line.add_child(structure)


func spawn_enemy():
	if enemies_to_spawn:
		var target = pick_target()
		if target:
			add_enemy(target)
	if !TEST_ENEMY:
		$Spawner.start(rand_range(1, 5))


func _on_Spawner_timeout():
	spawn_enemy()


func pick_target():
	var targets = []
	# Get all untargeted structures
	for i in globals.structures.keys():
		if !globals.structures[i].targeted:
			targets.append(i)
	var pick = false
	if targets.size():
		var i = randi() % targets.size()
		if TEST_ENEMY:
			i = TEST_TARGET_INDEX # Manually choose a target
		pick = globals.structures[targets[i]]
	pick.targeted = true
	return pick


func add_enemy(target):
	var enemy = enemy_scene.instance()
	enemy.target = target.get_parent().position
	enemy.position = Vector2(enemy.target.x + rand_range(-100, 100), -size.y)
	terrain.line.add_child(enemy)
	globals.add_entity(enemy, "enemies")
	map.add_enemy(enemy)


func _process(delta):
	process_inputs(delta)
	move_background(speed * delta)
	turn_player()
	move_player_sideways(delta)
	map.position_player(player, scroll_position, terrain)
	map.update_all_entities(scroll_position)
	stats.update()


func process_inputs(delta):
	if Input.is_action_pressed("ui_left"):
		speed = clamp(speed + THRUST * delta, -MAX_SPEED, MAX_SPEED)
	if Input.is_action_pressed("ui_right"):
		speed = clamp(speed - THRUST * delta, -MAX_SPEED, MAX_SPEED)
	if Input.is_action_pressed("ui_up") and player.position.y > TOP_LEVEL:
		player.move(0, -delta)
	if Input.is_action_pressed("ui_down") and player.position.y < terrain.base_level:
		player.move(0, delta)
	if Input.is_action_just_pressed("ui_accept"):
		fire_missile()


func fire_missile():
	var m = missile_scene.instance()
	terrain.add_child(m)
	m.start(terrain, scroll_position, speed, terrain.last_point.x)


func move_background(delta):
	scroll_position = wrapf(scroll_position + delta, 0, terrain.last_point.x)
	background.scroll_offset.x = scroll_position
	sky_pos += delta
	sky.set_offset(sky_pos)


func move_player_sideways(delta):
	if player.direction == LEFT and player.distance_to_right() > 0:
		change_position(delta)
	if player.direction == RIGHT and player.distance_to_left() > 0:
		change_position(-delta)


func change_position(delta):
	scroll_position += player.move(delta)


func turn_player():
	if player.direction == RIGHT and speed > 0:
		player.direction = LEFT
		anim.play("PlayerTurn")
		map.turn_player()
	if player.direction == LEFT and speed < 0:
		player.direction = RIGHT
		anim.play_backwards("PlayerTurn")
		map.turn_player()
