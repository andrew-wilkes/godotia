extends Area2D

# This implements an animated beam weapon

const TEST = false

var line
var shape
var tween
var dt = 0.15 # time/speed value
var step = 0 # animation step
var reach = 400 # max length of beam
var dir = 1 # direction sign to apply to x-scale

func _ready():
	line = $Line2D
	shape = $CollisionShape2D
	tween = $Tween
	# sync the widths of line and collision shape
	line.points[1].x = reach
	shape.shape.extents.x = reach / 2
	if TEST:
		play_tween()


func fire(_dir):
	dir = _dir
	reach = rand_range(200, 400) * dir
	position.x *= dir
	play_tween()


func _on_Tween_tween_all_completed():
	step += 1
	play_tween()


func play_tween():
	match step:
		0:
			line.position.x = 0
			tween.interpolate_property(line, "scale:x", 0, dir, dt)
			tween.interpolate_property(shape, "scale:x", 0, dir, dt)
			tween.interpolate_property(shape, "position:x", 0, reach / 2, dt)
			tween.interpolate_property(line, "modulate", Color(1, 1, 1), Color(1, 1, 0), dt)
		1:
			tween.interpolate_property(line, "position:x", 0, reach, dt)
			tween.interpolate_property(shape, "position:x", reach / 2, reach * 1.5, dt)
			tween.interpolate_property(line, "modulate", line.modulate, Color(1, 0.5, 0), dt)
		2:
			tween.interpolate_property(line, "scale:x", dir, 0, dt)
			tween.interpolate_property(line, "position:x", reach, reach * 2, dt)
			tween.interpolate_property(shape, "scale:x", dir, 0, dt)
			tween.interpolate_property(shape, "position:x", reach * 1.5, reach * 2, dt)
			tween.interpolate_property(line, "modulate", line.modulate, Color(0, 0, 1), dt)
			if TEST:
				# repeat with randomized position and reach
				position = Vector2(100, rand_range(100, 120))
				reach = rand_range(200, 400)
				step = -1
		3:
			# dispose of this object after the tweens complete
			queue_free()
			return
	tween.start()
