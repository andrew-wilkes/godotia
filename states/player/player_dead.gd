extends Node

var fsm: StateMachine
var p : Player

func enter():
	print("Player dead")
	p.kill()
