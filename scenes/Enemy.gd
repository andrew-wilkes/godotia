extends Area2D

enum { MOVING_TO_TARGET, DRAINING_ENERGY, MOVING_TO_PLAYER, LIFTING }

const SPEED = 100
const RATE_OF_DRAINING_ENERGY = 200

var state = MOVING_TO_TARGET
var target : Vector2
var structure : Structure
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
			if structure.get_energy_all_got(RATE_OF_DRAINING_ENERGY * delta):
				state = MOVING_TO_PLAYER
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
				# Destroy the structure
				globals.structures.erase(structure.get_instance_id())
				structure.queue_free()
				# Remove this enemy
				globals.enemies.erase(get_instance_id())
				queue_free()


func move(delta):
	position = position.move_toward(target, SPEED * delta)


func _on_Enemy_area_entered(_area):
	globals.remove_entity(self, "enemies")
	destroy()


func destroy():
	queue_free()


func _on_Enemy_body_entered(body):
	if body is Structure and state == MOVING_TO_TARGET:
		structure = body
		match structure.TYPE:
			"Building":
				state = LIFTING
				# Reparent the structure from terrain to enemy
				call_deferred("reparent_structure")
				target = Vector2(position.x, -8000)
			"EnergySource":
				state = DRAINING_ENERGY


func reparent_structure():
	structure.get_parent().remove_child(structure)
	structure.position = Vector2(-8, 8)
	add_child(structure)


func fire():
	if $ShotTimer.is_stopped():
		var shot = shot_scene.instance()
		shot.position = position
		shot.direction = (target - position).normalized()
		get_parent().add_child(shot)
		$ShotTimer.start(rand_range(globals.shots.fire_delay1, globals.shots.fire_delay2))
