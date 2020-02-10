extends ColorRect

class_name GSky

export var scroll_scale = 0.7


func resize(size):
	rect_size = size
	material.set_shader_param("viewport_size", size)


func set_offset(offset):
		material.set_shader_param("x_offset", -offset * scroll_scale)
