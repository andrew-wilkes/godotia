extends Node

var fsm: StateMachine
var p : Player
var connect = true
var anim : AnimationPlayer
var count

func enter():
	count = 0
	print("Player explode")
	anim = p.get_node("AnimationPlayer")
	if connect:
		connect = anim.connect("animation_finished", self, "animation_finished")
	anim.play("Explosion")


func animation_finished(_anim_name):
	count += 1
	if count == 1:
		fsm.change_to("player_lose_life")
