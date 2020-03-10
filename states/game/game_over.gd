extends Node

var fsm: StateMachine
var g

func enter():
	g.stats.stop_clock()
	g.enemies_to_spawn = 0
	# Freeze enemy activity
	for e in globals.enemies.values():
		e.get_node("States").change_to("enemy_idle")
	g.player.queue_free()
	g.map.player.queue_free()
	print("Game over")
	g.ui.pop_up_with_text("GAME OVER", true)
