extends Node

var fsm: StateMachine

func enter():
	globals.game.stats.stop_clock()
	globals.game.stats.enemies_to_spawn = 0
	globals.player.queue_free()
	print("Game over")
