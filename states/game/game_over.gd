extends Node

var fsm: StateMachine
var g

func enter():
	g.stats.stop_clock()
	g.enemies_to_spawn = 0
	g.player.queue_free()
	print("Game over")
	g.ui.pop_up_with_text("GAME OVER")
