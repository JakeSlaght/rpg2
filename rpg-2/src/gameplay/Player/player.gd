extends CharacterBody2D

@export var speed := 100.0
@onready var animated_sprite_2d: AnimatedSprite2D = %AnimatedSprite2D

func _ready() -> void:
	Bus.active_character_changed.connect(_set_character)

func _physics_process(_delta):
	var direction := InputGlobal.get_move_direction()

	velocity = direction * speed
	move_and_slide()

func _set_character(character: CharacterData) -> void:
	if character == null: return
	
	animated_sprite_2d.sprite_frames = character.sprite_frames
	
