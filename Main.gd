extends Node2D

const THRUST = 500
const MAX_SPEED = 500

var background
var terrain
var scroll_position = 0
var game_speed = 0
var scroll_speed = 0
var player_speed = 0
var player_pos = Vector2(0, 0) # Relative to center of viewport

func _ready():
	background = $ParallaxBackground
	terrain = find_node("Terrain")
	terrain.get_parent().motion_mirroring.x = terrain.end_pos


func _process(delta):
	process_inputs(delta)
	scroll_speed = game_speed - player_speed
	scroll_position += scroll_speed * delta
	background.scroll_offset.x = scroll_position


func process_inputs(delta):
	if Input.is_action_pressed("ui_left"):
		game_speed = clamp(game_speed + THRUST * delta, -MAX_SPEED, MAX_SPEED)
	if Input.is_action_pressed("ui_right"):
		game_speed = clamp(game_speed - THRUST * delta, -MAX_SPEED, MAX_SPEED)
