extends VFlowContainer

func update_score(score: int, pos := position):
	delete_score()
	show_score(score, pos)

func show_score(score: int, pos := position):
	for i in range(str(score).length()):
		var texture_node := TextureRect.new()
		texture_node.name = "digit" + str(i+1)
		add_child(texture_node)
	
	for i in range(str(score).length()):
		get_child(i).texture = load("res://assets/ui/letters/" + str(score)[i] +".png")
	
	position = pos
	

func delete_score():
	for child in get_children():
		remove_child(child)
		child.queue_free()
