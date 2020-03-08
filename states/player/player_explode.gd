extends Node

var fsm: StateMachine
var p : Player
var connect = true
var count

func enter():
	count = 0
	print("Player explode")
	if connect:
		connect = p.anim.connect("animation_finished", self, "animation_finished")
	p.anim.play("Explosion")


func animation_finished(_anim_name):
	count += 1
	if count == 1:
		fsm.change_to("player_lose_life")
