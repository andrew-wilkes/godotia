extends Node

var fsm: StateMachine
var e : Enemy
var connect = true
var count

func enter():
	count = 0
	if connect:
		connect = e.anim.connect("animation_finished", self, "animation_finished")
	e.anim.play("Explosion")


func animation_finished(_anim_name):
	count += 1
	if count == 1:
		fsm.change_to("enemy_dead")
