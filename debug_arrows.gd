extends Node2D

@onready var shadow_node: CharacterBody2D = $"../Ghosts/Shadow"
@onready var speedy_node: CharacterBody2D = $"../Ghosts/Speedy"
@onready var bashful_node: CharacterBody2D = $"../Ghosts/Bashful"
@onready var pokey_node: CharacterBody2D = $"../Ghosts/Pokey"

func draw_arrow(from: Vector2, to: Vector2, color: Color) -> void:
	var arrow_head_size = 20.0  # Ok başı uzunluğu (pixel)
		# Ana çizgiyi çiz
	draw_line(from, to, color, 2.0)

	# Yön vektörü (uçtan başa doğru)
	var direction: Vector2 = (from - to).normalized()

	# Ok başı çizgileri için açılı yönler
	var left_head: Vector2 = direction.rotated(deg_to_rad(20)) * arrow_head_size
	var right_head: Vector2 = direction.rotated(deg_to_rad(-20)) * arrow_head_size

	# Ok başı çizgilerini çiz
	draw_line(to, to + left_head, color, 2.0)
	draw_line(to, to + right_head, color, 2.0)


func draw_target_arrow():
	var ghost_array = [shadow_node, speedy_node, bashful_node, pokey_node]
	for ghost in ghost_array:
		if ghost.target != Vector2.ZERO and ghost.is_frightened == false:
			draw_arrow(ghost.position, ghost.target, ghost._color)
			

func _draw() -> void:
	if Globals.debug_mode == true:
		draw_target_arrow()

func _process(delta: float) -> void:
	queue_redraw()
		
