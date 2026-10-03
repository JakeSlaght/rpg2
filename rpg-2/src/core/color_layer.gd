extends Control

@onready var color: ColorRect = %Color
@onready var color_material: ShaderMaterial = color.material as ShaderMaterial

func _ready() -> void:
	Accessibility.set_color_material(color_material)
