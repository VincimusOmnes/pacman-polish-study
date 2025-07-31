extends Node

var cheat_activated := false

const GHOST_HOUSE_POSITION = Vector2(112, 115)
const GHOSTS_NAME := ["Shadow", "Speedy", "Bashful", "Pokey"]

var game_level: int = 1
var score: int = 0
var game_speed := 1.0 + float(game_level-1) / 10
var is_game_paused := true
var is_game_ended := false
var is_game_just_ended := false
var extra_life := 2
var pellets_eaten_string: Array[String] = []
var pellets_eaten := 0

var directions = [Vector2.RIGHT, Vector2.LEFT, Vector2.UP, Vector2.DOWN]

var direction_string = {
	Vector2.RIGHT: "right",
	Vector2.LEFT: "left",
	Vector2.UP: "up",
	Vector2.DOWN: "down"
}

const first_fruit_pellet := 5
const second_fruit_pellet := 170

const fruit_position := Vector2(202, 180)

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

const fruit_index_level := [0, 1, 2, 2, 3, 3, 4, 4, 5, 5, 6, 6] # access [game_level-1] and if level is more than 13 always key
var last_fruit_eaten: Array[int] = []

func get_reverse_direction(direction: Vector2) -> Vector2:
	match direction:
		Vector2.RIGHT:
			return Vector2.LEFT
		Vector2.LEFT:
			return Vector2.RIGHT
		Vector2.UP:
			return Vector2.DOWN
		Vector2.DOWN:
			return Vector2.UP
	return Vector2.ZERO
