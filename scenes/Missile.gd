extends Area2D

class_name Missile

var speed = 500
var direction = 1
var max_x

func _process(delta):
	position.x = wrapf(position.x + speed * delta * direction, 0, max_x)


func start(terrain, offset, player_speed, _max_x):
	max_x = _max_x
	# Make missile speed relative to plane speed
	speed += abs(player_speed)
	# Position it under the plane's wing
	position = globals.player.position + Vector2(terrain.last_point.x - offset, 10)
	if globals.player.direction:
		direction = 1
		$Sprite.flip_h = false
	else:
		direction = -1
		$Sprite.flip_h = true


func _on_Missile_area_entered(_area):
	destroy()


func _on_Lifetime_timeout():
	destroy()


func destroy():
	queue_free()
