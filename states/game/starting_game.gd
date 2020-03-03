extends Node

var fsm: StateMachine

func enter():
	globals.game.add_structures()
	globals.game.stats.reset()
	print("Game started")
	fsm.change_to("playing_level")
