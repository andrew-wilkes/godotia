extends Node

var fsm: StateMachine
var g

func enter():
	# Remove existing entities
	for e in globals.enemies.values():
		e.visible = false
	for s in globals.structures.values():
		s.visible = false
	g.map.update_all_entities()
	g.add_structures()
	g.stats.reset()
	g.add_player()
	print("Game started")
	fsm.change_to("playing_level")
