extends Control

@onready var score_node: VFlowContainer = $Score
@onready var level_node: VFlowContainer = $Level


func update_score(score: int, pos := position):
	delete_score()
	show_score(score, pos)

func show_score(score: int, pos := position):
	for i in range(str(score).length()):
		var texture_node := TextureRect.new()
		texture_node.name = "digit" + str(i+1)
		score_node.add_child(texture_node)
	
	for i in range(str(score).length()):
		score_node.get_child(i).texture = load("res://assets/ui/letters/" + str(score)[i] +".png")
	
	position = pos
	

func delete_score():
	for child in score_node.get_children():
		score_node.remove_child(child)
		child.queue_free()

	
func update_level(level: int, pos := position):
	delete_level()
	show_level(level, pos)

func show_level(level: int, pos := position):
	for i in range(str(level).length()):
		var texture_node := TextureRect.new()
		texture_node.name = "digit" + str(i+1)
		level_node.add_child(texture_node)
	
	for i in range(str(level).length()):
		level_node.get_child(i).texture = load("res://assets/ui/letters/" + str(level)[i] +".png")
	
	position = pos
	

func delete_level():
	for child in level_node.get_children():
		level_node.remove_child(child)
		child.queue_free()
