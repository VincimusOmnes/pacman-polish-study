extends Assets

@onready var animation_node := $AnimatedSprite2D
@onready var ghosts_node: Node2D = $"../Ghosts"

var pacman_speed: float = 60.0

var rotation_degree_from_direction = {
	Vector2.RIGHT: 0,
	Vector2.DOWN: 90,
	Vector2.LEFT: 180,
	Vector2.UP: 270
}


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
	animation_node.play()

func rotate_animation(direction: Vector2):
	animation_node.rotation_degrees = rotation_degree_from_direction[direction]

func _ready() -> void:
	PlayerManager.player_node = self
	play_move_animation()
	pause_animation()
	start_move(Vector2.LEFT, pacman_speed)
	rotate_animation(Vector2.LEFT)
	
func get_local_position():
	return Vector2(position.x - ghosts_node.position.x, position.y - ghosts_node.position.y)

func _process(delta: float) -> void:
	pass
	#var local_position := position - ghosts_node.position
	#print("Pacman Grid position:  X: " + str(int(local_position.x / Globals.GRID_SIZE)) + " Y: " + str(int(local_position.y / Globals.GRID_SIZE)))

func _physics_process(delta: float) -> void:
	if Globals.is_game_paused == false and Globals.is_game_ended == false:
		move_and_slide()
		if next_direction != Vector2.ZERO:
			if direction != next_direction and can_move(next_direction * 2):
				direction = next_direction
				rotate_animation(direction)
				resume_animation()

		if can_move(direction * 0.1):
			set_asset_velocity(direction, pacman_speed)
		else:
			velocity = Vector2.ZERO
			pause_animation()
	elif Globals.is_game_paused == false and Globals.is_game_ended == true:
		if Globals.is_game_just_ended == true:
			rotate_animation(Vector2.RIGHT)
			play_die_animation()
			Globals.is_game_just_ended = false
	elif Globals.is_game_paused == true and Globals.is_game_ended == true:
		pause_animation()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_up"):
		next_direction = Vector2.UP
	if event.is_action_pressed("ui_down"):
		next_direction = Vector2.DOWN
	if event.is_action_pressed("ui_left"):
		next_direction = Vector2.LEFT
	if event.is_action_pressed("ui_right"):
		next_direction = Vector2.RIGHT

var drag_start_pos := Vector2.ZERO
var drag_threshold := 20  # minimum hareket (piksel cinsinden) swipe sayılmalı

func _unhandled_input(event: InputEvent):
	if event is InputEventScreenTouch and event.pressed:
		drag_start_pos = event.position

	elif event is InputEventScreenDrag:
		var drag_vector = event.position - drag_start_pos

		if drag_vector.length() > drag_threshold:
			var dir = drag_vector.normalized()

			# Hangi yöne doğru kaydırıldığını kontrol et
			if abs(dir.x) > abs(dir.y):
				if dir.x > 0:
					next_direction = Vector2.RIGHT
				else:
					next_direction = Vector2.LEFT
			else:
				if dir.y > 0:
					next_direction = Vector2.DOWN
				else:
					next_direction = Vector2.UP

			# Drag algılandıktan sonra tekrar tetiklenmemesi için başlangıç pozisyonunu güncelle
			drag_start_pos = event.position
