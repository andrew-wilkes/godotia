extends Area2D

class_name Player

signal got_hit(sid)
signal crashed(sid)

const SPEED = Vector2(500, 500)
const MARGIN = 128

var direction : int
var sid = 0
var alive = true

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


func move(dx, dy = 0):
	var dv = SPEED * Vector2(dx, dy)
	position += dv
	if dx != 0: # Need to return value for sideways scroll
		return dv.x


func distance_to_left():
	return position.x - MARGIN


func distance_to_right():
	return get_viewport_rect().size.x - MARGIN - position.x


func explode(respawn):
	alive = respawn
	$AnimationPlayer.play("Explosion")


func respawn():
	$Sprite.material.set_shader_param("multiplier", 0)
	$Sprite.modulate.a = 1.0


func _on_AnimationPlayer_animation_finished(_anim_name):
	if alive:
		respawn()
