extends Node

var fsm: StateMachine

func enter():
	print("Game started")
	globals.game.add_player()
	globals.game.add_structures()
	globals.game.enemies_to_spawn = 10
	globals.game.spawn_enemy()
	globals.game.stats.reset()
