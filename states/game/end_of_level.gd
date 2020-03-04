extends Node

var fsm: StateMachine
var g

func enter():
	print("End of level")
	g.enemies_to_spawn = globals.game.stats.level * 10
	fsm.change_to("playing_level")
