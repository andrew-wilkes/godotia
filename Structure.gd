extends Sprite

class_name Structure

const ACCEL = 9.8

enum StructType { Building, Resource }
enum states { STATIC, FALLING, WITH_ENEMY, WITH_PLAYER }

export var title: String
export var description: String
export(StructType) var struct_type = StructType.Building
export(float, EXP, 0, 10000, 10) var max_energy = 100 setget set_max_energy
export(float, EXP, 0, 10000, 10) var population = 0

var body
var shape
var velocity = Vector2(0, 0)
var state = states.STATIC
var energy  setget set_energy

func _ready():
	body = get_child(0)
	set_energy(max_energy)


func _physics_process(delta):
	if state == states.FALLING:
		velocity.y += delta * ACCEL
		var collision = body.move_and_collide(velocity * delta)
		if collision:
			velocity.y = 0
			state = states.STATIC


func set_energy(value):
	energy = clamp(value, 0, INF)
	if struct_type == StructType.Resource:
		# Change the h value from 0.3 (Green) down to 0 (Red)
		modulate = Color().from_hsv(energy / max_energy * 0.3, 1, 1)


func set_max_energy(value):
	energy = value
	max_energy = value
