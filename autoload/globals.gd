extends Node

var player
var structures = {}
var enemies = {}

func add_entity(entity, target):
	get(target)[entity.get_instance_id()] = entity
