extends Node

var fsm: StateMachine
var p : Player

func enter():
	print("Player lose life")
	if globals.game.stats.lose_life() < 0:
		fsm.change_to("player_dead")
	else:
		fsm.change_to("player_respawn")
