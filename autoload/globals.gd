extends Node

var player
var terrain
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


func remove_entity(entity, target):
	get(target).erase(entity.get_instance_id())
