extends Area2D

class_name Player

signal got_hit
signal crashed
signal killed

const SPEED = Vector2(500, 500)
const MARGIN = 128

enum { LEFT, RIGHT }

var direction = RIGHT
var sid = 0
var alive = true
var body_entered
var anim

func _ready():
	for node in $States.get_children():
		node.p = self
	anim = $AnimationPlayer
	spawn()


func _process(delta):
	turn()
	move_sideways(delta)


func _on_Player_body_entered(body):
	body_entered = body


func _on_Player_area_entered(_area):
	if _area is Shot:
		emit_signal("got_hit")
	if _area is Enemy:
		emit_signal("crashed")


func spawn():
	$Spawn.play()
	anim.play_backwards("Explosion")


func kill():
	queue_free()
	emit_signal("killed")


func turn():
	if direction == RIGHT and globals.game.speed > 0:
		direction = LEFT
		anim.play("PlayerTurn")
		globals.game.map.turn_player()
	if direction == LEFT and globals.game.speed < 0:
		direction = RIGHT
		anim.play_backwards("PlayerTurn")
		globals.game.map.turn_player()


func move_sideways(delta):
	if direction == LEFT and distance_to_right() > 0:
		change_position(delta)
	if direction == RIGHT and distance_to_left() > 0:
		change_position(-delta)


func distance_to_left():
	return position.x - MARGIN


func distance_to_right():
	return get_viewport_rect().size.x - MARGIN - position.x


func change_position(delta):
	globals.game.scroll_position += move(delta)


func move(dx, dy = 0):
	var dv = SPEED * Vector2(dx, dy)
	position += dv
	if dx != 0: # Need to return value for sideways scroll
		return dv.x


func reset_size():
	get_node("Sprite").get_material().set_shader_param("multiplier", 0)
