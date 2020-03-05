extends Node

var fsm: StateMachine
var g

func enter():
	
	g.add_structures()
	g.stats.reset()
	g.add_player()
	print("Game started")
	fsm.change_to("playing_level")
