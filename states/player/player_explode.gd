extends Node

var fsm: StateMachine
var p : Player
var connect = true
var anim : AnimationPlayer
var valid

func enter():
	valid = true
	print("Player explode")
	anim = p.get_node("AnimationPlayer")
	if connect:
		connect = anim.connect("animation_finished", self, "animation_finished")
	anim.play("Explosion")


func animation_finished(_anim_name):
	#BUG Seems to get called twice
	if valid:
		fsm.change_to("player_lose_life")
		valid = false
