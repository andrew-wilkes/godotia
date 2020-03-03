extends Area2D

class_name Player

signal got_hit(sid)
signal crashed(sid)

const SPEED = Vector2(500, 500)
const MARGIN = 128

enum { LEFT, RIGHT }

var direction = RIGHT
var sid = 0
var alive = true

func _process(delta):
	turn()
	move_sideways(delta)


func _on_Player_body_entered(body):
	if !sid and body is Structure and body.state == body.states.FALLING:
		# Catch falling structure
		sid = body.get_instance_id()
		body.state = body.states.STATIC
		body.call_deferred("reparent", self, self, Vector2(4, 16), sid)
		globals.output("%s to player" % sid)
	elif sid and globals.structures.has(sid) and body.collision_mask == 0 and body.get_child_count() < 2:
		# Allow re-targeting of structure
		var s = globals.structures[sid]
		s.targeted = false
		# Place structure on empty terrain flat
		s.call_deferred("reparent", self, body.get_parent(), body.position)
		globals.output("%s from player" % sid)


func _on_Player_area_entered(_area):
	if _area is Shot:
		emit_signal("got_hit", sid)
	if _area is Enemy:
		emit_signal("crashed", sid)


func explode(respawn):
	alive = respawn
	$AnimationPlayer.play("Explosion")


func respawn():
	$Sprite.material.set_shader_param("multiplier", 0)
	$Sprite.modulate.a = 1.0


func _on_AnimationPlayer_animation_finished(_anim_name):
	if alive:
		respawn()


func turn():
	if direction == RIGHT and globals.game.speed > 0:
		direction = LEFT
		$AnimationPlayer.play("PlayerTurn")
		globals.game.map.turn_player()
	if direction == LEFT and globals.game.speed < 0:
		direction = RIGHT
		$AnimationPlayer.play_backwards("PlayerTurn")
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
