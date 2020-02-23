extends Area2D

enum { MOVING_TO_TARGET, DRAINING_ENERGY, MOVING_TO_PLAYER, LIFTING, DEAD }

const SPEED = 100
const RATE_OF_DRAINING_ENERGY = 100

var state = MOVING_TO_TARGET
var target : Vector2
var sid = 0
var shot_scene = preload("res://scenes/Shot.tscn")
var in_range : bool
var shot_range_squared : float

func _init():
	shot_range_squared = pow(rand_range(globals.shots.range1, globals.shots.range2), 2)


func _process(delta):
	match state:
		MOVING_TO_TARGET:
			move(delta)
		DRAINING_ENERGY:
			if globals.structures[sid].get_energy_all_got(RATE_OF_DRAINING_ENERGY * delta):
				state = MOVING_TO_PLAYER
				globals.structures[sid].targeted = false
				sid = 0
		MOVING_TO_PLAYER:
			target = globals.player.global_position - get_parent().global_position
			move(delta)
			in_range = shot_range_squared >= (target - position).length_squared()
			if in_range:
				modulate = Color(1, 0, 0)
				fire()
			else:
				modulate = Color(1, 1, 1)
		LIFTING:
			move(delta)
			if global_position.y < 0:
				if sid:
					got_building()
					sid = 0
				destroy()


func move(delta):
	position = position.move_toward(target, SPEED * delta)


func _on_Enemy_area_entered(_area):
	# Got hit by player or a missile
	if sid:
		if state == LIFTING:
			globals.structures[sid].state = globals.structures[sid].states.FALLING
			globals.call_deferred("reparent_structure", self, get_parent(), self.position)
		else:
			# Was leeching off an energy source
			globals.structures[sid].targeted = false
			globals.structures[sid].charging = true
			state = DEAD
	got_hit()
	destroy()


func destroy():
	visible = false


func _on_Enemy_body_entered(body):
	if body is Structure and state == MOVING_TO_TARGET:
		sid = body.get_instance_id()
		match body.TYPE:
			"Building":
				state = LIFTING
				# Reparent the structure from terrain to enemy
				globals.call_deferred("reparent_structure", self, self, Vector2(-8, 8), sid)
				target = Vector2(position.x, -8000)
			"EnergySource":
				state = DRAINING_ENERGY


func reparent_structure(new_parent: Node, pos: Vector2, _sid = 0):
	var s = globals.structures[sid]
	s.get_parent().remove_child(s)
	s.position = pos
	new_parent.add_child(s)
	sid = _sid


func fire():
	if $ShotTimer.is_stopped():
		var shot = shot_scene.instance()
		shot.position = position
		shot.direction = (target - position).normalized()
		get_parent().add_child(shot)
		$ShotTimer.start(rand_range(globals.shots.fire_delay1, globals.shots.fire_delay2))


func got_hit():
	pass


func got_building():
	globals.structures[sid].visible = false
	print("got_building")
