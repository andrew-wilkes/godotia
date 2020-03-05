extends Node

var fsm: StateMachine
var g

func enter():
	g.stats.stop_clock()
	g.enemies_to_spawn = 0
	for e in globals.enemies.values():
		e.queue_free()
	globals.enemies.clear()
	g.player.queue_free()
	print("Game over")
	g.ui.pop_up_with_text("GAME OVER")
