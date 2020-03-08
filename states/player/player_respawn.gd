extends Node

var fsm: StateMachine
var p : Player

func enter():
	print("Player respawn")
	p.spawn()
	fsm.change_to("player_active")
