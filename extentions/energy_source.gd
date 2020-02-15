extends Structure

const TYPE = "EnergySource"

const CHARGING_RATE = 10

export(float, EXP, 0, 10000, 10) var max_energy = 100 setget set_max_energy

var energy  setget set_energy
var charging = true

func _ready():
	body = get_child(0)
	set_energy(max_energy)


func _process(delta):
	if charging and energy < max_energy:
		set_energy(energy + CHARGING_RATE * delta)


func set_energy(value):
	energy = clamp(value, 0, max_energy)
	# Change the h value from 0.3 (Green) down to 0 (Red)
	modulate = Color().from_hsv(energy / max_energy * 0.3, 1, 1)


func set_max_energy(value):
	energy = value
	max_energy = value


func get_energy(amount):
	charging = false
	set_energy(energy - amount)
	if energy <= 0:
		charging = true
	return charging
