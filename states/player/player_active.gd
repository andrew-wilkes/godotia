extends Node

var fsm: StateMachine
var p : Player
var connect = true

func enter():
	print("Player active")
	p.reset_size()
	if connect:
		connect = p.connect("got_hit", self, "got_hit")
		connect = p.connect("crashed", self, "crashed")


func process(_delta):
	if p.body_entered:
		if p.payload:
			try_to_place_stucture()
		else:
			try_to_catch_stucture()
		p.body_entered = null


func try_to_place_stucture():
	# Check if it's an unoccupied terrain flat
	if p.body_entered.collision_mask == 0 and p.body_entered.get_child_count() < 2:
		var s = p.payload
		s.targeted = false
		s.reparent(p.body_entered, Vector2(0, 0))
		p.payload = null
		globals.output("Player placed %s" % s.get_instance_id())
		p.get_node("Action").play()


func try_to_catch_stucture():
	if  p.body_entered is Structure and p.body_entered.state == p.body_entered.states.FALLING:
		p.payload = p.body_entered
		p.payload.state = p.payload.states.STATIC
		p.payload.reparent(p, Vector2(4, 16))
		globals.output("%s to player" % p.payload.get_instance_id())
		p.get_node("Buzz").play()


func got_hit():
	fsm.change_to("player_hit")


func crashed():
	fsm.change_to("player_explode")
