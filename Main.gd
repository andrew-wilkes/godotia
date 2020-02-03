extends Node2D

var background
var terrain
var scroll_position = 0

func _ready():
	background = $ParallaxBackground
	terrain = find_node("Terrain")
	terrain.get_parent().motion_mirroring.x = terrain.end_pos


func _process(delta):
	scroll_position += delta * 500
	background.scroll_offset.x = scroll_position
