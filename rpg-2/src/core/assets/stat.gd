extends Resource
class_name Stat

signal stat_depleted
signal stat_changed(current: int,current_max: int)

@export_range(0,999) var base_max: int = 100

var current_max: int = -1
var current: int = -1 : set = _on_stat_set

func _init() -> void:
	_setup_stat.call_deferred()

func _setup_stat() -> void:
	current_max = base_max
	current = current_max

func _on_stat_set(new_stat: int) -> void:
	var previous := current
	current = clampi(new_stat, 0, current_max)
	
	if current == previous:
		return
	
	stat_changed.emit(current, current_max)

	if previous > 0 and current == 0:
		stat_depleted.emit()
