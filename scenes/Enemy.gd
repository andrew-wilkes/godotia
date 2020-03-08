extends Area2D

class_name Enemy

signal enemy_killed(points)

enum { MOVING_TO_TARGET, DRAINING_ENERGY, MOVING_TO_PLAYER, LIFTING, DEAD }

const SPEED = 100
const RATE_OF_DRAINING_ENERGY = 100
const POINTS = 10
const BONUS_POINTS = 50

var state = MOVING_TO_TARGET
var target = {}
var sid = 0
var shot_scene = preload("res://scenes/Shot.tscn")
var shot_range_squared : float
var body_entered
var area_entered
var anim

func _ready():
	shot_range_squared = pow(rand_range(globals.shots.range1, globals.shots.range2), 2)
	for node in $States.get_children():
		node.e = self
	anim = $AnimationPlayer


func move(delta):
	position = position.move_toward(target.position, SPEED * delta)


func _on_Enemy_area_entered(area):
	# Got hit by player or a missile
	area_entered = area


func destroy():
	visible = false


func _on_Enemy_body_entered(body):
	if body is Structure:
		body_entered = body


func fire():
	if $ShotTimer.is_stopped():
		var shot = shot_scene.instance()
		shot.position = position
		shot.direction = (target.position - position).normalized()
		get_parent().add_child(shot)
		$ShotTimer.start(rand_range(globals.shots.fire_delay1, globals.shots.fire_delay2))


func got_building():
	globals.structures[sid].visible = false
	globals.output("Got_building")


func emit_killed(points):
	emit_signal("enemy_killed", points)
