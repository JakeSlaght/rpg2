extends CharacterBody2D

@export var speed := 100.0

func _physics_process(_delta):
	var direction := InputGlobal.get_move_direction()

	velocity = direction * speed
	move_and_slide()
