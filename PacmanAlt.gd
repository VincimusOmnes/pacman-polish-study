class_name PacmanAlt extends Assets

const ROTATION_SPEED: float = 4.0
const BOUNCE_DAMPING: float = 0.7

@onready var ghosts_node: Node2D = $"../Ghosts"
@onready var animation_node := $AnimatedSprite2D
@onready var particles: GPUParticles2D = $GPUParticles2D


var input_direction: Vector2

func _ready() -> void:
	PlayerManager.player_node = self
	play_move_animation()
	
func _physics_process(delta: float) -> void:
	
	if Globals.is_game_paused == false and Globals.is_game_ended == true:
		if Globals.is_game_just_ended == true:
			play_die_animation()
			particles.emitting = false
			Globals.is_game_just_ended = false
		return

	rotation_degrees += input_direction.x * ROTATION_SPEED
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
		input_direction = Vector2.LEFT
	if event.is_action_pressed("ui_right"):
		input_direction = Vector2.RIGHT
	
	if input_direction == Vector2.LEFT:
		if event.is_action_released("ui_left"):
			input_direction = Vector2.ZERO
	if input_direction == Vector2.RIGHT:
		if event.is_action_released("ui_right"):
			input_direction = Vector2.ZERO
			
func play_move_animation():
	animation_node.sprite_frames.set_animation_loop("pacman_move", true)
	animation_node.play("pacman_move")
	animation_node.speed_scale = Globals.game_speed

func play_die_animation():
	animation_node.sprite_frames.set_animation_loop("pacman_die", false)
	animation_node.play("pacman_die")
	animation_node.speed_scale = 1.0

func stop_animation():
	animation_node.stop()

func pause_animation():
	animation_node.pause()

func resume_animation():
	pass
	#animation_node.play()

func get_local_position():
	return Vector2(position.x - ghosts_node.position.x, position.y - ghosts_node.position.y)
