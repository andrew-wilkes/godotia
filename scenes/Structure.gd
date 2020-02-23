extends KinematicBody2D

class_name Structure, "res://textures/structures/aparto.png"

const ACCEL = 20
const CRASH_SPEED = 40

enum states { STATIC, FALLING }

export var title: String
export var description: String

var velocity = Vector2(0, 0)
var state = states.STATIC
var targeted = false


func _physics_process(delta):
	if state == states.FALLING:
		velocity.y += delta * ACCEL
		var collision = move_and_collide(velocity * delta)
		if collision:
			if velocity.y >= CRASH_SPEED:
				print("Structure crash speed: ", velocity.y)
				destroy()
			velocity.y = 0
			state = states.STATIC
		if position.y > 0:
			print("Structure hit ground")
			destroy()


func destroy():
	state = states.STATIC
	visible = false
