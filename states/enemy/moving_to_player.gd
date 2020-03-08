extends Node

var fsm: StateMachine
var e : Enemy

func enter():
	pass


func process(delta):
	if e.area_entered:
		e.emit_killed(e.BONUS_POINTS)
		fsm.change_to("enemy_explode")
	else:
		hunt_player(delta)


func hunt_player(delta):
	e.target.position = globals.player.global_position - e.get_parent().global_position
	e.move(delta)
	var in_range = e.shot_range_squared >= (e.target.position- e.position).length_squared()
	if in_range:
		e.modulate = Color(1, 0, 0)
		e.fire()
	else:
		e.modulate = Color(1, 1, 1)
