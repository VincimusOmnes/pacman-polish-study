class_name Shake extends Node

## The intensity of the shake
@export var shake_strength: float = 30.0
## The speed the shake diminshes
@export var shake_decay_rate: float = 5.0

## Shake via positioning or shake via camera offset
@export var should_shake_offset: bool = false

@onready var parent = get_parent()

var shake_amount: float = 0
var original_position: Vector2

func _process(delta: float) -> void:
	if shake_amount:
		shake_amount = lerpf(shake_amount, 0, shake_decay_rate * delta)
		handle_shake(delta)
	
func handle_shake(_delta: float) -> void:
	if should_shake_offset:
		parent.offset = get_random_position_2d(shake_amount, shake_amount, original_position)
	else:
		parent.position = get_random_position_2d(shake_amount, shake_amount, original_position)
		
func start_shake() -> void:
	# It's possible we don't want to set this every time since multiple rapid shakes will break some stuff
	if should_shake_offset:
		original_position = parent.offset
	else:
		original_position = parent.position
	shake_amount = shake_strength
	
func get_random_position_2d(x_range: float, y_range: float, from_position: Vector2) -> Vector2:
	return Vector2(
		randf_range(from_position.x - x_range, from_position.x + x_range),
		randf_range(from_position.y - y_range, from_position.y + y_range)
	)
