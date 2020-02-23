extends Area2D

class_name Shot

var speed = 300
var direction : Vector2

func _process(delta):
	position += direction * speed * delta


func _on_Lifetime_timeout():
	destroy()


func destroy():
	queue_free()
