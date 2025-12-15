extends AnimationPlayer

@onready var parent: TutorialStep = get_parent()

func _ready() -> void:
	parent.step_displayed.connect(_on_step_displayed)
	
func _on_step_displayed() -> void:
	play("eat")
