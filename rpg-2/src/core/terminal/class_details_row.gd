extends HBoxContainer
class_name ClassDetailsRow
@onready var class_name_label: Label = %ClassName
@onready var class_level: Label = %ClassLevel
@onready var class_xp: TextureProgressBar = %ClassXP

func setup(class_data: ClassData) -> void:
	class_name_label.text = Globals.ClassType.keys()[class_data.class_type]
	class_level.text = str(class_data.level)
	class_xp.max_value = class_data.xp.current_max
	class_xp.value = class_data.xp.current
