extends Node

var fsm: StateMachine
var e : Enemy

func enter():
	e.queue_free()
