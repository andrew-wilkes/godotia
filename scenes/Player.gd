extends Area2D

const SPEED = Vector2(500, 500)
const MARGIN = 128

var direction : int

func _on_Player_body_entered(body):
	$Label.text = body.name


func _on_Player_area_entered(area):
	$Label.text = area.name


func move(dx, dy = 0):
	var dv = SPEED * Vector2(dx, dy)
	position += dv
	if dx != 0: # Need to return value for sideways scroll
		return dv.x


func distance_to_left():
	return position.x - MARGIN


func distance_to_right():
	return get_viewport_rect().size.x - MARGIN - position.x
