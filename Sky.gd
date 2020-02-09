extends TextureRect

export var scroll_scale = 0.7

func _ready():
# warning-ignore:return_value_discarded
	get_tree().get_root().connect("size_changed", self, "_resize")
	_resize()


func _resize():
	var size = get_viewport_rect().size
	rect_size = size
	material.set_shader_param("viewport_size", size)


func set_offset(offset):
		material.set_shader_param("x_offset", -offset * scroll_scale)
