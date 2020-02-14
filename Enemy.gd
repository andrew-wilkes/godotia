extends Area2D

enum { MOVING_TO_TARGET, DRAINING_ENERGY, MOVING_TO_PLAYER, LIFTING }

const SPEED = 100
const RATE_OF_DRAINING_ENERGY = 50

var state = MOVING_TO_TARGET
var target : Vector2
var structure : Structure

func _process(delta):
	match state:
		MOVING_TO_TARGET:
			move(delta)
		DRAINING_ENERGY:
			structure.energy -= RATE_OF_DRAINING_ENERGY * delta
			if structure.energy <= 0:
				state = MOVING_TO_PLAYER
		MOVING_TO_PLAYER:
			target = globals.player.global_position - get_parent().global_position
			move(delta)
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
	pass # Replace with function body.


func _on_Enemy_body_entered(body):
	if body.get_parent() is Structure and state == MOVING_TO_TARGET:
		structure = body.get_parent()
		match structure.structType:
			Structure.StructType.Building:
				state = LIFTING
				# Reparent the structure from terrain to enemy
				call_deferred("reparent_structure")
				target = Vector2(position.x, -8000)
			Structure.StructType.Resource:
				state = DRAINING_ENERGY


func reparent_structure():
	structure.get_parent().remove_child(structure)
	structure.position = Vector2(-8, 8)
	add_child(structure)
