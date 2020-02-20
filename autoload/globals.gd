extends Node

var player
var terrain
var structures = {}
var enemies = {}

func add_entity(entity, target):
	get(target)[entity.get_instance_id()] = entity


func remove_entity(entity, target):
	get(target).erase(entity.get_instance_id())
