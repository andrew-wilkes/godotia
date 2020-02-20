extends Area2D

var speed = 500
var direction = 1

func _process(delta):
	var x = position.x + speed * delta * direction
	if x > globals.terrain.last_point.x:
		x -= globals.terrain.last_point.x
	if x < 0:
		x += globals.terrain.last_point.x
	position.x = x


func start(terrain, offset, player_speed):
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
