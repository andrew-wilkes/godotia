extends ColorRect

var coor_scale : Vector2
var line

func _ready():
	line = $Line2D
	coor_scale = get_viewport_rect().size / self.rect_size
	print(coor_scale)


func set_terrain_points(points: PoolVector2Array):
	for point in points:
		line.add_point(point * coor_scale)
