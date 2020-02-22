extends Area2D

enum { MOVING_TO_TARGET, DRAINING_ENERGY, MOVING_TO_PLAYER, LIFTING }

const SPEED = 100
const RATE_OF_DRAINING_ENERGY = 200

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


func _on_Enemy_area_entered(area):
	if sid:
		if area.name == "Player":
			call_deferred("reparent_structure", area, Vector2())
		else:
			globals.structures[sid].state = globals.structures[sid].states.FALLING
			call_deferred("reparent_structure", get_parent(), self.position)
	got_hit()
	destroy()


func destroy():
	globals.remove_entity(self, "enemies")


func _on_Enemy_body_entered(body):
	if body is Structure and state == MOVING_TO_TARGET:
		sid = body.get_instance_id()
		match body.TYPE:
			"Building":
				state = LIFTING
				# Reparent the structure from terrain to enemy
				call_deferred("reparent_structure", $Hook, Vector2(-8, 8), sid)
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
	globals.structures.erase(sid)
	print("got_building")
