extends Area2D
class_name InteractionArea

@export var action_name: String = 'Interact'

var interact: Callable = func():
	pass

func _on_body_entered(body: Node2D) -> void:	
	Bus.register_interaction_area.emit(self)
	
func _on_body_exited(body: Node2D) -> void:
	Bus.unregister_interaction_area.emit(self)
