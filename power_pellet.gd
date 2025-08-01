extends Area2D

@onready var animation_node = $AnimatedSprite2D
@onready var game_node = $"../.."
@onready var sounds_node: Node = $"../../Sounds"

func play_animation():
	animation_node.play("blink")

func stop_animation():
	animation_node.stop()

func _on_body_entered(body: Node2D) -> void:
	if body.name == "Pacman":
		game_node.add_score(50)
		Globals.ghost_eaten_since_last_frighten = 0
		Globals.pellets_eaten_string.append(name)
		game_node.check_ghost_spawn()
		game_node.eat_pellet()
		sounds_node.play_eat_pellet_sound()
		game_node.frighten_ghosts()
		queue_free()
