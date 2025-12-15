extends Area2D

@onready var game_node = $"../.."
@onready var sounds_node: Node = $"../../Sounds"
@onready var particles: GPUParticles2D = $GPUParticles2D
@onready var sprite: Sprite2D = $Sprite2D

func _ready() -> void:
	particles.finished.connect(_on_particles_finished)

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("pacman"):
		particles.emitting = true
		sprite.visible = false
		Globals.pellets_eaten_string.append(name)
		game_node.add_score(10)
		game_node.check_ghost_spawn()
		game_node.eat_pellet()
		sounds_node.play_eat_pellet_sound()

func _on_particles_finished() -> void:
	queue_free()
	
