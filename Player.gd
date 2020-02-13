extends Area2D

func _ready():
	pass


func _on_Player_body_entered(body):
	$Label.text = body.name


func _on_Player_area_entered(area):
	$Label.text = area.name
