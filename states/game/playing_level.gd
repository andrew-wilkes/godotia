extends Node

var fsm: StateMachine
var g

func enter():
	g = globals.game
	g.add_player()
	g.spawn_enemy()
	globals.ig(g.map.connect("end_of_level", self, "increase_level"))
	globals.ig(g.stats.connect("game_over", self, "game_over"))


func increase_level():
	fsm.change_to("end_of_level")


func game_over():
	fsm.change_to("game_over")


func process(delta):
	globals.game.stats.update()
	g.move_background(g.speed * delta)
	g.map.position_player(g.player, g.scroll_position, g.terrain)
	g.map.update_all_entities(g.scroll_position)
	process_inputs(delta)


func process_inputs(delta):
	if Input.is_action_pressed("ui_left"):
		g.speed = clamp(g.speed + g.THRUST * delta, -g.MAX_SPEED, g.MAX_SPEED)
	if Input.is_action_pressed("ui_right"):
		g.speed = clamp(g.speed - g.THRUST * delta, -g.MAX_SPEED, g.MAX_SPEED)
	if Input.is_action_pressed("ui_up") and g.player.position.y > g.TOP_LEVEL:
		g.player.move(0, -delta)
	if Input.is_action_pressed("ui_down") and g.player.position.y < g.terrain.base_level:
		g.player.move(0, delta)
	if Input.is_action_just_pressed("ui_accept"):
		g.fire_missile()
