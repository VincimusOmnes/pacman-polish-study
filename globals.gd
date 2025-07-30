extends Node

var game_level: int = 1
var score: int = 0
var game_speed := 2.0 + float(game_level-1) / 10
var is_game_paused := true
var is_game_ended := false
var is_game_just_ended := false
var extra_life := 2

var directions = [Vector2.RIGHT, Vector2.LEFT, Vector2.UP, Vector2.DOWN]

var direction_string = {
	Vector2.RIGHT: "right",
	Vector2.LEFT: "left",
	Vector2.UP: "up",
	Vector2.DOWN: "down"
}

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
