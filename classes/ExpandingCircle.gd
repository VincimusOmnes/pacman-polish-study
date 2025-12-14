@tool
class_name ExpandingCircle extends Node2D

@export var color: Color = Color.WHITE

@export var duration: float
@export var max_radius: float
@export var max_thickness: float

@export var radius_interpolation: Curve
@export var thickness_interpolation: Curve

@export var one_shot: bool = false

var elapsed_time: float = 0.0
var should_play: bool = true

func _draw() -> void:
	# % of duration but interped on the curve
	var current_radius: float = radius_interpolation.sample(elapsed_time/duration) * max_radius
	var current_thickness: float = thickness_interpolation.sample(elapsed_time/duration) * max_thickness
	# This isn't affected by glow so it looks a little out of place
	draw_arc(Vector2(0,0), current_radius, 0, 360, 50, color, current_thickness)

func _process(delta: float) -> void:
	if elapsed_time > duration:
		elapsed_time = 0.0
		if one_shot:
			should_play = false
		else:
			# If we turn off one shot we want to be able to start again
			should_play = true
	elapsed_time += delta
	
	if !should_play:
		return
		
	queue_redraw()
