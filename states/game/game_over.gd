extends Node

var fsm: StateMachine

func enter():
	globals.game.stats.stop_clock()
	globals.player.queue_free()
	print("Game over")
