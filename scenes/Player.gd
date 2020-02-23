extends Area2D

const SPEED = Vector2(500, 500)
const MARGIN = 128

var direction : int
var sid = 0

func _on_Player_body_entered(body):
	if body is Structure and body.state == body.states.FALLING:
		sid = body.get_instance_id()
		body.state = body.states.STATIC
		globals.call_deferred("reparent_structure", self, self, Vector2(4, 16), sid)


func _on_Player_area_entered(_area):
	pass


func move(dx, dy = 0):
	var dv = SPEED * Vector2(dx, dy)
	position += dv
	if dx != 0: # Need to return value for sideways scroll
		return dv.x


func distance_to_left():
	return position.x - MARGIN


func distance_to_right():
	return get_viewport_rect().size.x - MARGIN - position.x
