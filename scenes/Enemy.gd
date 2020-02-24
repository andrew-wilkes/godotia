extends Area2D

class_name Enemy

signal enemy_killed(points)

enum { MOVING_TO_TARGET, DRAINING_ENERGY, MOVING_TO_PLAYER, LIFTING, DEAD }

const SPEED = 100
const RATE_OF_DRAINING_ENERGY = 100

var state = MOVING_TO_TARGET
var target : Vector2
var sid = 0
var shot_scene = preload("res://scenes/Shot.tscn")
var in_range : bool
var shot_range_squared : float
var points = 10
const BONUS_POINTS = 50

func _init():
	shot_range_squared = pow(rand_range(globals.shots.range1, globals.shots.range2), 2)


func _process(delta):
	match state:
		MOVING_TO_TARGET:
			move(delta)
		DRAINING_ENERGY:
			if sid and globals.structures[sid].get_energy_all_got(RATE_OF_DRAINING_ENERGY * delta):
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
				state = DEAD
				destroy()


func move(delta):
	position = position.move_toward(target, SPEED * delta)


func _on_Enemy_area_entered(area):
	# Got hit by player or a missile
	if sid:
		var s = globals.structures[sid]
		if state == LIFTING:
			s.state = s.states.FALLING
			s.call_deferred("reparent", self, get_parent(), self.position)
		else:
			# Was leeching off an energy source
			s.targeted = false
			s.charging = true
	if area.name != "Player":
		if state == MOVING_TO_PLAYER:
			points = BONUS_POINTS
		emit_signal("enemy_killed", points)
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
				#globals.call_deferred("reparent_structure", self, self, Vector2(-8, 8), sid)
				body.call_deferred("reparent", self, self, Vector2(-8, 8), sid)
				target = Vector2(position.x, -8000)
			"EnergySource":
				state = DRAINING_ENERGY


func fire():
	if $ShotTimer.is_stopped():
		var shot = shot_scene.instance()
		shot.position = position
		shot.direction = (target - position).normalized()
		get_parent().add_child(shot)
		$ShotTimer.start(rand_range(globals.shots.fire_delay1, globals.shots.fire_delay2))


func got_building():
	globals.structures[sid].visible = false
	globals.output("Got_building")
