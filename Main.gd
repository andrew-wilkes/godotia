extends Node2D

const THRUST = 500
const MAX_SPEED = THRUST # Same number re-use, saves editing later maybe?
const PLAYER_SPEED = Vector2(THRUST, THRUST)
const PLAYER_MARGIN = 128
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
var player_direction = RIGHT

func _ready():
	background = $ParallaxBackground
	sky = find_node("Sky")
	player = $Player
	anim = $AnimationPlayer
	map = $Map
	# Allow for renaming of the parallax layer(s) later, so using find_node() and get_parent()
	terrain = find_node("Terrain")
	terrain.get_parent().motion_mirroring.x = terrain.last_point.x
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
	player.position.x = PLAYER_MARGIN
	# Add structures to terrain flats
	Structures.coors = terrain.get_points_for_structures(Structures.DENSITY)
	for point in Structures.coors:
		var item = Structures.get_item(point, terrain.GRID_SIZE)
		item.add_to_group("structures")
		terrain.line.add_child(item)
	map.add_structures(terrain.GRID_SIZE)


func _process(delta):
	process_inputs(delta)
	move_background(delta)
	turn_player()
	move_player_sideways(delta)


func process_inputs(delta):
	if Input.is_action_pressed("ui_left"):
		speed = clamp(speed + THRUST * delta, -MAX_SPEED, MAX_SPEED)
	if Input.is_action_pressed("ui_right"):
		speed = clamp(speed - THRUST * delta, -MAX_SPEED, MAX_SPEED)
	if Input.is_action_pressed("ui_up") and player.position.y > TOP_LEVEL:
		player.position.y -= PLAYER_SPEED.y * delta
	if Input.is_action_pressed("ui_down") and player.position.y < terrain.base_level:
		player.position.y += PLAYER_SPEED.y * delta


func move_background(delta):
	scroll_position += speed * delta
	background.scroll_offset.x = scroll_position
	sky.set_offset(scroll_position)


func move_player_sideways(delta):
	var player_speed = PLAYER_SPEED.x * delta
	if player_direction == LEFT and get_player_distance_to_right() > 0:
		change_position(player_speed)
	if player_direction == RIGHT and get_player_distance_to_left() > 0:
		change_position(-player_speed)


func change_position(delta):
	player.position.x += delta
	scroll_position += delta


func get_player_distance_to_left():
	return player.position.x - PLAYER_MARGIN


func get_player_distance_to_right():
	return get_viewport_rect().size.x - PLAYER_MARGIN - player.position.x


func turn_player():
	if player_direction == RIGHT and speed > 0:
		player_direction = LEFT
		print("Player turned to left")
		anim.play("PlayerTurn")
	if player_direction == LEFT and speed < 0:
		player_direction = RIGHT
		print("Player turned to right")
		anim.play_backwards("PlayerTurn")
