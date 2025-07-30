extends CharacterBody2D

class_name Assets
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D

@export var direction: Vector2
var next_direction: Vector2 = Vector2.ZERO
var possible_direction: Array[Vector2] = []
var speed: float

var is_in_tunnel := false

func is_overlapping_with(other_body: CharacterBody2D) -> bool:
	var space_state = get_world_2d().direct_space_state

	var shape = collision_shape_2d.shape  # kendi shape'ini al
	var transform = get_global_transform()

	var params = PhysicsShapeQueryParameters2D.new()
	params.set_shape(shape)
	params.set_transform(transform)
	params.set_collide_with_areas(false)
	params.set_collide_with_bodies(true)
	params.set_exclude([self])

	var results = space_state.intersect_shape(params)

	for res in results:
		if res.collider == other_body:
			return true

	return false

func start_move(direction: Vector2, speed: float):
	set_asset_velocity(direction, speed)

func set_asset_velocity(direction := direction, speed := speed):
	self.speed = speed
	self.direction = direction
	velocity = speed * direction * Globals.game_speed

func can_move(direction: Vector2) -> bool:
	var test_pos = global_transform
	return not test_move(test_pos, direction)
	
