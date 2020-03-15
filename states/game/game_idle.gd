extends Node

var fsm: StateMachine
var g
var connect = true

func enter():
	if connect:
		connect = g.ui.connect("play_game", self, "play_game")
		connect = g.ui.connect("quit_game", self, "quit_game")
	g.ui.pop_up_with_text("WELCOME TO GODOTIA!")
	g.load_high_score()
	g.stats.score = 0


func play_game():
	g.ui.hide()
	fsm.change_to("starting_game")


func quit_game():
	get_tree().quit()
