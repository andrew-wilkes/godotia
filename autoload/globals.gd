extends Node

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


func reparent_structure(caller: Node, dest: Node, pos: Vector2, _sid = 0):
	if caller.sid:
		var s = structures[caller.sid]
		s.get_parent().remove_child(s)
		s.position = pos
		dest.add_child(s)
		caller.sid = _sid
