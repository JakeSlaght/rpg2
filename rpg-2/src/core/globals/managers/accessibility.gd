class_name AccessibilityManager
extends Node

var color_overlay: Enums.ColorMode = Enums.ColorMode.DEFAULT:
	set(value):
		color_overlay = value
		_apply_color_overlay()

var color_material: ShaderMaterial


func set_color_material(material: ShaderMaterial) -> void:
	color_material = material
	_apply_color_overlay()


func _apply_color_overlay() -> void:
	if color_material:
		print_debug("color_selected index:", color_overlay)
		color_material.set_shader_parameter("color_selected", color_overlay)
