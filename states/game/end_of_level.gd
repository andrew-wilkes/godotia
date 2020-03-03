extends Node

var fsm: StateMachine

func enter():
	print("End of level")
	globals.player.queue_free()
	globals.game.enemies_to_spawn = globals.game.stats.level * 10
	fsm.change_to("playing_level")
