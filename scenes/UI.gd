extends PopupPanel

class_name UI

signal play_game
signal quit_game

func pop_up_with_text(txt = null, delay_play_button_enable = false, delay = 0.3):
	if txt:
		$VBoxContainer/Label.text = txt
	$Tween1.interpolate_property(self, "rect_position", rect_position * 1.5, rect_position, delay)
	$Tween2.interpolate_property(self, "rect_scale", rect_scale * 0, rect_scale, delay)
	$Tween1.start()
	$Tween2.start()
	popup_centered()
	if delay_play_button_enable:
		disable_play_button(true)
		$Timer.start()


func disable_play_button(disabled = false):
	$VBoxContainer/Buttons/PlayButton.disabled = disabled


func _on_PlayButton_button_down():
	emit_signal("play_game")


func _on_ExitButton_button_down():
	emit_signal("quit_game")
