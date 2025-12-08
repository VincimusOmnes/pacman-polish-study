extends CharacterBody2D

const ROTATION_SPEED: float = 4.0
const BOUNCE_DAMPING: float = 0.7

@onready var ghosts_node: Node2D = $"../Ghosts"

var direction: Vector2
var is_in_tunnel: bool = false

func _ready() -> void:
	PlayerManager.player_node = self
	
func _physics_process(delta: float) -> void:
	#move_and_slide()
	rotation_degrees += direction.x * ROTATION_SPEED
	velocity *= 0.9
	velocity += Vector2.from_angle(rotation) * delta * 300
	
	move_and_slide()
	if get_slide_collision_count():
		var normal = get_slide_collision(0).get_normal()
		var bounce_vector = velocity - 2 * (velocity.dot(normal)) * normal
		velocity = bounce_vector * BOUNCE_DAMPING
		
	
func _input(event: InputEvent) -> void:
	#if event.is_action_pressed("ui_up"):
		#
	#if event.is_action_pressed("ui_down"):
		
	#if event.is_action("ui_left"):
	if event.is_action_pressed("ui_left"):
		direction = Vector2.LEFT
	if event.is_action_pressed("ui_right"):
		direction = Vector2.RIGHT
	
	if direction == Vector2.LEFT:
		if event.is_action_released("ui_left"):
			direction = Vector2.ZERO
	if direction == Vector2.RIGHT:
		if event.is_action_released("ui_right"):
			direction = Vector2.ZERO
			

func is_overlapping_with(ghost: Node) -> void:
	pass

func resume_animation() -> void:
	pass

func pause_animation() -> void:
	pass

func get_local_position() -> Vector2:
	return Vector2(position.x - ghosts_node.position.x, position.y - ghosts_node.position.y)
