extends Area2D

class_name Fruit

@onready var sprite_2d_node: Sprite2D = $Sprite2D
@onready var timer_node: Timer = $Timer


const fruit_score := [100, 300, 500, 700, 1000, 2000, 3000, 5000]
const fruit_sprite := [
	preload("res://assets/fruit_items/cherry.png"),
	preload("res://assets/fruit_items/strawberry.png"),
	preload("res://assets/fruit_items/orange.png"),
	preload("res://assets/fruit_items/apple.png"),
	preload("res://assets/fruit_items/melon.png"),
	preload("res://assets/fruit_items/galaxian.png"),
	preload("res://assets/fruit_items/bell.png"),
	preload("res://assets/fruit_items/key.png"),
]

var index: int

func _init(index: int = 0) -> void:
	if index < fruit_sprite.size():
		self.index = index
		sprite_2d_node.texture = fruit_sprite[index]
		timer_node.start(10.0)


func _on_timer_timeout() -> void:
	queue_free()


func _on_body_entered(body: Node2D) -> void:
	
	queue_free()
