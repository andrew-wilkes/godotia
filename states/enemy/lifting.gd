extends Node

var fsm: StateMachine
var e : Enemy

func enter():
	pass


func process(delta):
	e.move(delta)
	if e.global_position.y < 0:
		if e.sid:
			e.got_building()
			e.sid = 0
		fsm.change_to("enemy_explode")
	elif e.area_entered:
		# Move building parent from enemy to terrain and make it fall
		var s = globals.structures[e.sid]
		s.state = s.states.FALLING
		s.reparent(e, e.get_parent(), e.position)
		fsm.change_to("enemy_explode")
