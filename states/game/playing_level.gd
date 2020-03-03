extends Node

var fsm: StateMachine

func enter():
	var g = globals.game
	g.add_player()
	g.spawn_enemy()
	globals.ig(g.map.connect("end_of_level", self, "increase_level"))
	globals.ig(g.stats.connect("game_over", self, "game_over"))


func increase_level():
	fsm.change_to("end_of_level")


func game_over():
	fsm.change_to("game_over")


func process(_delta):
	globals.game.stats.update()
