extends Area2D

@onready var game_node = $"../.."
@onready var sounds_node: Node = $"../../Sounds"

func _on_body_entered(body: Node2D) -> void:
	if body.name == "Pacman":
		Globals.pellets_eaten += 1
		Globals.score += 10
		Globals.pellets_eaten_string.append(name)
		game_node.check_ghost_spawn()
		game_node.check_cruise_elroy()
		sounds_node.play_eat_pellet_sound()
		Globals.score += 10
		queue_free()
