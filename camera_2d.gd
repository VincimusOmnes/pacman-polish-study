extends Camera2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var shake: Shake = $Shake
@onready var shockwave: Shockwave = $CanvasLayer/Shockwave




var focused_node: Node = null


func _ready() -> void:
	SignalBus.camera_focused.connect(_on_camera_focused)
	animation_player.animation_finished.connect(_on_animation_finished)
	
func _on_animation_finished(animation_name: StringName) -> void:
	if animation_name == "slow_breathe_out":
		shake.start_shake()
		shockwave.start_shockwave()
		get_tree().paused = false
	
func _on_camera_focused(node_to_focus: Node) -> void:
	# What I want is like a slow zoom out with a crash zoom in following it
	animation_player.play("slow_breathe_out")
	focused_node = node_to_focus
	get_tree().paused = true
	
func _process(_delta: float) -> void:
	if focused_node:
		if position != focused_node.position:
			position = lerp(position, focused_node.position, 0.05)
			#position = focused_node.position
