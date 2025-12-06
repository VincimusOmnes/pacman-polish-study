class_name Shockwave extends ColorRect

## A material with a shockwave shader attached
@export var shader_material: ShaderMaterial

@export var radius_start: float
@export var radius_end: float
@export var duration: float

var shader: Material
var current_radius: float
var time = 0.0

func _ready() -> void:
	if !shader_material:
		push_error("Shader material missing from shockwave: %s" % self)
		return
	material = shader_material

func _process(delta: float) -> void:
	if current_radius < radius_end:
		time += delta
		var progress: float = time / duration
		var ease_amount = ease(progress, 0.2) 
		current_radius = radius_end * ease_amount
		get_material().set_shader_parameter("radius", current_radius)

func start_shockwave() -> void:
	time = 0.0
	current_radius = radius_start
	visible = true
