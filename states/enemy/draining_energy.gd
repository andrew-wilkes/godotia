extends Node

var fsm: StateMachine
var e : Enemy

func enter():
	pass


func process(delta):
	if e.area_entered:
		e.target.object.targeted = false
		e.target.object.charging = true
		e.emit_killed(e.POINTS)
		fsm.change_to("enemy_explode")
	elif e.target.object.get_energy_all_got(e.RATE_OF_DRAINING_ENERGY * delta):
		e.target.object.targeted = false
		fsm.change_to("moving_to_player")
