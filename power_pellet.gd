extends Area2D

var alt_pacman: PackedScene = preload("res://pacman_alt.tscn")

@onready var animation_node = $AnimatedSprite2D
@onready var game_node = $"../.."
@onready var sounds_node: Node = $"../../Sounds"

@onready var camera: Camera2D = get_viewport().get_camera_2d()

func play_animation():
	animation_node.play("blink")

func stop_animation():
	animation_node.stop()
	
func handle_polish() -> void:
	var new_pacman: Assets = switch_pacmans()
	SignalBus.camera_focused.emit(new_pacman)
	
func switch_pacmans() -> Assets:
	var old_pacman: Assets = PlayerManager.player_node
	var new_pacman: Assets = alt_pacman.instantiate()
	old_pacman.get_parent().add_child(new_pacman)
	new_pacman.position = old_pacman.position
	set_new_pacman_direction(new_pacman, old_pacman.next_direction)
	PlayerManager.player_node = new_pacman
	old_pacman.queue_free()
	return new_pacman
	
func set_new_pacman_direction(new_pacman: Assets, old_direction: Vector2) -> void:
	var new_rotation: float = 0
	match(old_direction):
		Vector2.UP:
			new_rotation = -90
		Vector2.DOWN:
			new_rotation = 90
		Vector2.LEFT:
			new_rotation = 180
	new_pacman.rotation_degrees = new_rotation

func _on_body_entered(body: Node2D) -> void:
	if body.name == "Pacman":
		handle_polish()
		game_node.add_score(50)
		Globals.ghost_eaten_since_last_frighten = 0
		Globals.pellets_eaten_string.append(name)
		game_node.check_ghost_spawn()
		game_node.eat_pellet()
		sounds_node.play_eat_pellet_sound()
		game_node.frighten_ghosts()
		queue_free()
