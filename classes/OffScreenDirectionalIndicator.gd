class_name OffScreenDirectionalIndicator extends VisibleOnScreenNotifier2D

@export var node_to_point: Node2D
@export var icon: Node2D

@onready var parent: Node = get_parent()


func _ready() -> void:
	return
	#screen_entered.connect(_on_screen_entered)
	#screen_exited.connect(_on_screen_exited)

func _process(_delta: float) -> void:
	if !is_on_screen():
		icon.global_rotation = 0
		if !node_to_point.visible:
			node_to_point.visible = true
		
		var bounds: Rect2 = get_camera_rect()
		
		node_to_point.global_position.x = clamp(
			global_position.x, 
			bounds.position.x,
			bounds.end.x
		)
		node_to_point.global_position.y = clamp(
			global_position.y, 
			bounds.position.y, 
			bounds.end.y
		)
		node_to_point.look_at(PlayerManager.player_node.global_position)
		# This is necessary if the node isn't pointing left initially
		#node_to_point.rotate(-PI/2)
	else:
		if node_to_point.visible:
			node_to_point.visible = false
			
func get_camera_rect() -> Rect2:
	var camera = get_viewport().get_camera_2d()
	var camera_centre = camera.get_screen_center_position()
	var screen_size = get_viewport().get_visible_rect().size
	screen_size = (screen_size / camera.zoom) / 2
	var bounds: Rect2 = Rect2()
	bounds.position.x = camera_centre.x - screen_size.x
	bounds.position.y = camera_centre.y - screen_size.y
	bounds.end.x = camera_centre.x + screen_size.x
	bounds.end.y = camera_centre.y + screen_size.y
	return bounds
