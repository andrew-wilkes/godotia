extends Area2D

var speed = 500
var direction = 1

func _process(delta):
	position.x += speed * delta * direction


func _on_Lifetime_timeout():
	destroy()


func destroy():
	queue_free()


func start(offset, p_speed):
	speed += abs(p_speed)
	position = globals.player.position + Vector2(offset, 10)
	if globals.player.direction:
		direction = 1
		$Sprite.flip_h = false
	else:
		direction = -1
		$Sprite.flip_h = true
	$Lifetime.start()
