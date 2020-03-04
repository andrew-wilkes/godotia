extends PopupPanel

class_name UI

signal play_game
signal quit_game

func pop_up_with_text(txt):
	$VBoxContainer/Label.text = txt
	popup_centered()


func _on_PlayButton_button_down():
	emit_signal("play_game")


func _on_ExitButton_button_down():
	emit_signal("quit_game")
