extends Node

var fsm: StateMachine
var e : Enemy

func enter():
	pass


func process(delta):
	e.move(delta)
	if e.global_position.y < 0:
		if e.payload:
			e.got_building()
		fsm.change_to("enemy_dead")
	elif e.area_entered:
		# Move building parent from enemy to terrain and make it fall
		var s = e.payload
		s.state = s.states.FALLING
		s.reparent(e.get_parent(), e.position)
		fsm.change_to("enemy_explode")
