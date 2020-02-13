extends Sprite

class_name Structure

const ACCEL = 9.8

enum StructType { Building, Resource }
enum states { STATIC, FALLING, WITH_ENEMY, WITH_PLAYER }

export var title: String
export var description: String
export(StructType) var structType = StructType.Building
export(float, 100) var energy = 100
export(float, EXP, 0, 10000, 10) var population = 0

var body
var shape
var velocity = Vector2(0, 0)
var state = states.STATIC

func _ready():
	body = get_child(0)


func _physics_process(delta):
	if state == states.FALLING:
		velocity.y += delta * ACCEL
		var collision = body.move_and_collide(velocity * delta)
		if collision:
			velocity.y = 0
			state = states.STATIC
