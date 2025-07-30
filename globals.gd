extends Node

var cheat_activated := false

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

const first_item_pellet := 70
const second_item_pellet := 170



const item_index_level := [0, 1, 2, 2, 3, 3, 4, 4, 5, 5, 6, 6] # access [game_level-1] and if level is more than 13 always key

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
