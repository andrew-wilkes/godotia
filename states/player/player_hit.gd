extends Node

var fsm: StateMachine
var p : Player

func enter():
	print("Player hit")
	if globals.game.stats.reduce_health() <= 0:
		fsm.change_to("player_explode")
	else:
		p.get_node("Buzz").play()
		fsm.change_to("player_active")
