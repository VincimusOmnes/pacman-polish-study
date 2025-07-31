extends Node2D

@onready var ghost_gate_node: StaticBody2D = $GhostGate
@onready var sprite_2d_node: Sprite2D = $Sprite2D

func blink_maze():
	var maze_sprite := preload("res://assets/maze.png")
	var maze_white_sprite := preload("res://assets/maze_white.png")
	for i in range(3):
		sprite_2d_node.texture = maze_white_sprite
		await get_tree().create_timer(0.2).timeout
		sprite_2d_node.texture = maze_sprite
		await get_tree().create_timer(0.2).timeout

func open_ghost_gate(ghost: CharacterBody2D):
	ghost_gate_node.collision_layer = ghost_gate_node.collision_layer &  ~ghost.collision_mask

func close_ghost_gate(ghost: CharacterBody2D):
	ghost_gate_node.collision_layer = ghost_gate_node.collision_layer | (ghost.collision_mask & 0xFF00)


func _on_warp_tunnel_body_entered(body: Node2D) -> void:
	if body is CharacterBody2D:
		body.is_in_tunnel = !body.is_in_tunnel


func _on_warp_tunnel_right_end_body_entered(body: Node2D) -> void:
	if body is CharacterBody2D:
		body.position.x -= sprite_2d_node.texture.get_size().x - 10


func _on_warp_tunnel_left_end_body_entered(body: Node2D) -> void:
	if body is CharacterBody2D:
		body.position.x += sprite_2d_node.texture.get_size().x - 10


func _on_warp_tunnel_body_exited(body: Node2D) -> void:
	if body is CharacterBody2D:
		body.is_in_tunnel = !body.is_in_tunnel


func _on_ghost_house_body_entered(body: Node2D) -> void:
	if Globals.GHOSTS_NAME.has(body.name) and body.is_died == true:
		body.returned_ghost_house()
