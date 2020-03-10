extends Node

var fsm: StateMachine
var g

func enter():
	# Remove existing entities
	get_tree().call_group("enemies", "queue_free")
	get_tree().call_group("building", "queue_free")
	get_tree().call_group("energy_source", "queue_free")
	yield(get_tree(), "idle_frame")
	g.map.remove_entities()
	g.add_structures()
	g.stats.reset()
	g.add_player()
	print("Game started")
	#fsm.change_to("game_over")
	fsm.change_to("playing_level")
