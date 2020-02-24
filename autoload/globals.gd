extends Node

const OUTPUT = true

var player
var structures = {}
var enemies = {}
var shots = {
	"range1": 200,
	"range2": 500,
	"fire_delay1": 0.2,
	"fire_delay2": 1.1
}

func add_entity(entity, target):
	get(target)[entity.get_instance_id()] = entity


func get_status():
	var pop = 0
	var energy = 0
	for s in structures.values():
		if s.TYPE == "Building":
			pop += s.population
		else:
			energy += s.energy
	return { p = pop, e = energy }


func output(msg):
	if OUTPUT:
		print(msg)
