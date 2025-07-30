extends CanvasLayer

@onready var pacman_node: CharacterBody2D = $"../Pacman"

func _ready():
	var platform = OS.get_name()
	if platform == "Android" or platform == "iOS":
		show()
	else:
		hide()
		pass


func _on_up_pressed() -> void:
	var event = InputEventAction.new()
	event.action = "ui_up"
	event.pressed = true
	Input.parse_input_event(event)


func _on_down_pressed() -> void:
	var event = InputEventAction.new()
	event.action = "ui_down"
	event.pressed = true
	Input.parse_input_event(event)


func _on_left_pressed() -> void:
	var event = InputEventAction.new()
	event.action = "ui_left"
	event.pressed = true
	Input.parse_input_event(event)


func _on_right_pressed() -> void:
	var event = InputEventAction.new()
	event.action = "ui_right"
	event.pressed = true
	Input.parse_input_event(event)
