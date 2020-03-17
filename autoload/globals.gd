extends Node

const OUTPUT = true

var game
var player
var shots = {
	"range1": 200,
	"range2": 500,
	"fire_delay1": 0.2,
	"fire_delay2": 1.1
}


func get_status():
	var pop = 0
	for b in get_tree().get_nodes_in_group("building"):
		pop += b.population
	var energy = 0
	for e in get_tree().get_nodes_in_group("energy_source"):
		energy += e.energy
	return { p = pop, e = energy }


func output(msg):
	if OUTPUT:
		print(msg)
