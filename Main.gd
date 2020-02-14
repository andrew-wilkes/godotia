extends Node2D

const THRUST = 500
const MAX_SPEED = 500
const TOP_LEVEL = 14

enum { LEFT, RIGHT }

var background : ParallaxBackground
var sky: GSky
var terrain : Terrain
var anim : AnimationPlayer
var player
var map: Map
var scroll_position
var speed = 0
var enemy_scene = preload("res://Enemy.tscn")

func _ready():
	background = $ParallaxBackground
	sky = find_node("Sky")
	player = $Player
	globals.player = player
	player.direction = RIGHT
	anim = $AnimationPlayer
	map = $Map
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
	var size = get_viewport_rect().size
	terrain.set_base_level(size.y)
	sky.resize(size)
	map.resize(terrain, size.y)
	map.rect_position.x = (size.x - map.rect_size.x) / 2


func start_game():
	player.position.x = player.MARGIN
	# Add structures to terrain flats
	Structures.coors = terrain.get_points_for_structures(Structures.DENSITY)
	for point in Structures.coors:
		var item = Structures.get_item(point, terrain.GRID_SIZE)
		globals.structures[item.get_instance_id()] = item
		terrain.line.add_child(item)
	map.add_structures()
	map.add_player(player, scroll_position, terrain)
	var enemy = enemy_scene.instance()
	enemy.target = globals.structures.values()[17].position
	enemy.position = Vector2(3600, -400)
	terrain.line.add_child(enemy)
	globals.enemies[enemy.get_instance_id()] = enemy
	map.add_enemy(enemy)


func _process(delta):
	process_inputs(delta)
	move_background(delta)
	turn_player()
	move_player_sideways(delta)
	map.position_player(player, scroll_position, terrain)
	map.update_structures(scroll_position)
	map.update_enemies(scroll_position)


func process_inputs(delta):
	if Input.is_action_pressed("ui_left"):
		speed = clamp(speed + THRUST * delta, -MAX_SPEED, MAX_SPEED)
	if Input.is_action_pressed("ui_right"):
		speed = clamp(speed - THRUST * delta, -MAX_SPEED, MAX_SPEED)
	if Input.is_action_pressed("ui_up") and player.position.y > TOP_LEVEL:
		player.move(0, -delta)
	if Input.is_action_pressed("ui_down") and player.position.y < terrain.base_level:
		player.move(0, delta)


func move_background(delta):
	scroll_position += speed * delta
	if scroll_position > terrain.last_point.x:
		scroll_position -= terrain.last_point.x
	if scroll_position < 0:
		scroll_position += terrain.last_point.x
	background.scroll_offset.x = scroll_position
	sky.set_offset(scroll_position)


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
