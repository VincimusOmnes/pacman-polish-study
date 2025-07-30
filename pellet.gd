extends Area2D

@onready var game_node = $"../.."
@onready var sounds_node: Node = $"../../Sounds"

func _on_body_entered(body: Node2D) -> void:
	if body.name == "Pacman":
		Globals.pellets_eaten_string.append(name)
		game_node.add_score(10)
		game_node.check_ghost_spawn()
		game_node.eat_pellet()
		sounds_node.play_eat_pellet_sound()
		queue_free()
