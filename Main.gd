extends Node2D

const THRUST = 500
const MAX_SPEED = 500
const PLAYER_MARGIN = 128
const PLAYER_SIDE_SPEED = 500
const PLAYER_VERTICAL_SPEED = 500

enum { LEFT, RIGHT }

var background
var terrain
var scroll_position = 0
var speed = 0
var player_direction = RIGHT
var player

func _ready():
	background = $ParallaxBackground
	terrain = find_node("Terrain")
	terrain.get_parent().motion_mirroring.x = terrain.end_pos
	player = $Player


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
	if Input.is_action_pressed("ui_up"):
		if player.position.y > 0:
			player.position.y -= PLAYER_VERTICAL_SPEED * delta
	if Input.is_action_pressed("ui_down"):
		if player.position.y < terrain.base_level:
			player.position.y += PLAYER_VERTICAL_SPEED * delta


func move_background(delta):
	scroll_position += speed * delta
	background.scroll_offset.x = scroll_position


func turn_player():
	if player_direction == RIGHT and speed > 0:
		player_direction = LEFT
		print("Player turned to left")
	if player_direction == LEFT and speed < 0:
		player_direction = RIGHT
		print("Player turned to right")


func move_player_sideways(delta):
	var player_speed = PLAYER_SIDE_SPEED * delta
	if player_direction == LEFT and get_player_distance_to_right() > 0:
		player.position.x += player_speed
		scroll_position += player_speed
	if player_direction == RIGHT and get_player_distance_to_left() > 0:
		player.position.x -= player_speed
		scroll_position -= player_speed


func get_player_distance_to_left():
	return player.position.x - PLAYER_MARGIN


func get_player_distance_to_right():
	return get_viewport_rect().size.x - PLAYER_MARGIN - player.position.x
