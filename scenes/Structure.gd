extends KinematicBody2D

class_name Structure, "res://textures/structures/aparto.png"

const ACCEL = 20
const CRASH_SPEED = 40

enum states { STATIC, FALLING }

export var title: String
export var description: String

var velocity = Vector2(0, 0)
var state = states.STATIC
var targeted = false

func _ready():
	var mat = get_node("Sprite").get_material().duplicate(true)
	get_node("Sprite").set_material(mat)


func _physics_process(delta):
	if state == states.FALLING:
		velocity.y += delta * ACCEL
		var collision = move_and_collide(velocity * delta)
		if collision:
			if velocity.y >= CRASH_SPEED:
				globals.output("Structure crash speed: %s" % velocity.y)
				destroy()
			velocity.y = 0
			state = states.STATIC
		if position.y > 0 and velocity.y > 1:
			globals.output("Structure hit ground")
			destroy()


func destroy():
	state = states.STATIC
	$AnimationPlayer.play("Explosion")


func reparent(caller: Node, dest: Node, pos: Vector2, _sid = 0):
	if get_parent() != dest:
		globals.output("Reparent: %s to %s" % [caller.sid, dest.name])
		get_parent().remove_child(self)
		position = pos
		#dest.call_deferred("add_child", self)
		dest.add_child(self)
		caller.sid = _sid


func _on_AnimationPlayer_animation_finished(_anim_name):
	visible = false
