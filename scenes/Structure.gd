extends KinematicBody2D

class_name Structure, "res://textures/structures/aparto.png"

const ACCEL = 9.8

enum states { STATIC, FALLING, WITH_ENEMY, WITH_PLAYER }

export var title: String
export var description: String

var velocity = Vector2(0, 0)
var state = states.STATIC


func _physics_process(delta):
	if state == states.FALLING:
		velocity.y += delta * ACCEL
		var collision = move_and_collide(velocity * delta)
		if collision:
			velocity.y = 0
			state = states.STATIC
