extends Area2D

class_name Fruit

@onready var sprite_2d_node: Sprite2D = $Sprite2D
@onready var timer_node: Timer = $Timer
@onready var game_node: Node2D = $".."
@onready var sounds_node: Node = $"../Sounds"



var index: int

func _ready() -> void:
	sprite_2d_node.texture = Globals.fruit_sprite[index]
	timer_node.start(10.0)

func set_fruit_index(index: int = 0) -> void:
	if index < Globals.fruit_sprite.size():
		self.index = index



func _on_timer_timeout() -> void:
	queue_free()


func _on_body_entered(body: Node2D) -> void:
	if body.name == "Pacman":
		game_node.add_score(Globals.fruit_score[index])
		Globals.last_fruit_eaten.append(index)
		game_node.draw_last_eaten_fruits()
		sounds_node.play_eat_fruit_sound()
		queue_free()
