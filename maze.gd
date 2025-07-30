extends Node2D

@onready var ghost_gate_node: StaticBody2D = $GhostGate
@onready var sprite_2d_node: Sprite2D = $Sprite2D


func open_ghost_gate(ghost: CharacterBody2D):
	ghost_gate_node.collision_layer = ghost_gate_node.collision_layer & ~ghost.collision_layer

func close_ghost_gate():
	ghost_gate_node.collision_layer = 0b111111111111111111111111


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
