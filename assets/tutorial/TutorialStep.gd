class_name TutorialStep extends Control

signal step_displayed
signal step_hidden

#@export var signal_node: Node # Not using this currently
@export var signal_autoload_string: String = "SignalBus"
@export var signal_name_to_display_on: String
@export var signal_name_to_hide_on: String
@export var hide_timeout: float = 2.0
@export var should_pause_tree: bool = false
@export var should_display_once: bool = true

var has_displayed: bool = false

var signal_bus: Node

func _ready() -> void:
	visible = false
	var signal_bus_path: String = "/root/" + signal_autoload_string
	if has_node(signal_bus_path):
		signal_bus = get_node(signal_bus_path)
		if signal_bus.has_signal(signal_name_to_display_on):
			signal_bus.connect(signal_name_to_display_on, _on_display)
		if signal_bus.has_signal(signal_name_to_hide_on):
			signal_bus.connect(signal_name_to_hide_on, _on_hide)

# In theory these could be extended for complex tutorial steps
# By nulling the params we can use existing signals
# Still want to offer a position though because we'll use it often enough
func _on_display(pos = null, _p2 = null, _p3 = null, _p4 = null, _p5 = null) -> void:
	if should_display_once and has_displayed:
		return
	
	visible = true
	has_displayed = true
	step_displayed.emit()
	
	if position is Vector2:
		global_position = pos
	if should_pause_tree:
		get_tree().paused = true
	if !signal_name_to_hide_on:
		_on_hide()
	
func _on_hide(_p1 = null, _p2 = null, _p3 = null, _p4 = null, _p5 = null) -> void:
	await get_tree().create_timer(hide_timeout).timeout
	visible = false
	step_hidden.emit()
	if should_pause_tree:
		get_tree().paused = false
