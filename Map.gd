extends ColorRect

class_name Map

var coor_scale : Vector2
var line: Line2D

func _ready():
	line = $Line2D


func set_points(terrain: Terrain):
	line.clear_points()
	for i in terrain.line.get_point_count():
		line.add_point(terrain.line.points[i] * coor_scale)


func resize(terrain: Terrain, y_size):
	coor_scale = self.rect_size / Vector2(terrain.line.get_point_count() * terrain.GRID_SIZE, y_size)
	line.position = Vector2(0, terrain.base_level * coor_scale.y)
	set_points(terrain)
