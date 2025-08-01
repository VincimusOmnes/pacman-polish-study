extends Node2D

@onready var maze_node: Node2D = $Maze
@onready var blink_timer_node: Timer = $BlinkTimer
@onready var frighten_timer_node: Timer = $FrightenTimer
@onready var ghost_mode_cycle_node: Timer = $GhostModeCycle
@onready var ghosts_node: Node2D = $Ghosts
@onready var extra_lifes_node: Container = $ExtraLifes
@onready var last_eaten_fruits_node: HFlowContainer = $LastEatenFruits
@onready var score_node: VFlowContainer = $Score


@onready var pacman_node: CharacterBody2D = $Pacman
@onready var shadow_node: CharacterBody2D = $Ghosts/Shadow
@onready var speedy_node: CharacterBody2D = $Ghosts/Speedy
@onready var bashful_node: CharacterBody2D = $Ghosts/Bashful
@onready var pokey_node: CharacterBody2D = $Ghosts/Pokey
@onready var power_pellets_node: Node2D = $PowerPellets
@onready var pellets_node: Node2D = $Pellets
@onready var sounds_node: Node = $Sounds

var ghost_mode_index := 0
var ghost_mode_timer := [7.0, 20.0, 7.0, 20.0, 5.0]
var level_end := false

func reborn(reduce_extra_life: bool):
	if reduce_extra_life:
		Globals.extra_life -= 1
	if Globals.extra_life >= 0:
		pass
	else:
		reset_game_variables()
	var current_scene = get_tree().current_scene
	var scene_path = current_scene.scene_file_path
	get_tree().change_scene_to_file(scene_path)

func reset_game_variables():
	Globals.game_level = 1
	Globals.score = 0
	Globals.is_game_paused = true
	Globals.is_game_ended = false
	Globals.is_game_just_ended = false
	Globals.extra_life = 2
	Globals.pellets_eaten_string.clear()
	Globals.pellets_eaten = 0
	Globals.last_fruit_eaten.clear()

func check_game_over():
	if Globals.extra_life < 1:
		print("GAME OVER!..")

func eat_pellet():
	Globals.pellets_eaten += 1
	check_fruit_appear()
	check_cruise_elroy()

func add_extra_life():
	Globals.extra_life += 1
	draw_extra_life_icon()

func add_score(value: int):
	Globals.score += value
	score_node.update_score(Globals.score)
	if Globals.score / 10000 == (Globals.score-value) / 10000 + 1:
		add_extra_life()

func start_game():
	Globals.is_game_paused = false
	pacman_node.resume_animation()
	ghost_mode_cycle_node.start(ghost_mode_timer[0])
	ghost_mode_index += 1

func pause_game():
	ghost_mode_cycle_node.paused = true
	Globals.is_game_paused = true
	pacman_node.pause_animation()
	sounds_node.stop_siren()

func resume_game():
	ghost_mode_cycle_node.paused = false

func check_fruit_appear():
	if Globals.pellets_eaten == Globals.first_fruit_pellet or Globals.pellets_eaten == Globals.second_fruit_pellet: # first:
		var fruit := preload("res://fruit.tscn").instantiate()
		if Globals.game_level <= Globals.fruit_index_level.size():
			fruit.set_fruit_index(Globals.fruit_index_level[Globals.game_level-1])
		else:
			fruit.set_fruit_index(Globals.fruit_index_level[-1]+1)
		call_deferred("add_child", fruit)
		fruit.position = Globals.fruit_position
		

func check_cruise_elroy():
	if Globals.pellets_eaten >= 230:
		shadow_node.enter_cruise_elory(2)
	elif Globals.pellets_eaten >= 220:
		shadow_node.enter_cruise_elory(1)
	else:
		shadow_node.enter_cruise_elory(0)

func check_ghost_spawn():
	if Globals.pellets_eaten >= 6 and speedy_node.did_spawned == false and speedy_node.is_spawning == false:
		speedy_node.spawn_ghost()
	if Globals.pellets_eaten >= 30 and bashful_node.did_spawned == false and bashful_node.is_spawning == false:
		bashful_node.spawn_ghost()
	if Globals.pellets_eaten >= 60 and pokey_node.did_spawned == false and pokey_node.is_spawning == false:
		pokey_node.spawn_ghost()

func _on_ghost_mode_cycle_timeout() -> void:
	for ghost in ghosts_node.get_children():
		ghost.scatter = !ghost.scatter
		ghost.chase = !ghost.chase
	if ghost_mode_index < ghost_mode_timer.size():
		ghost_mode_cycle_node.start(ghost_mode_timer[ghost_mode_index])
		ghost_mode_index += 1
	else:
		ghost_mode_cycle_node.stop()
		for ghost in ghosts_node.get_children():
			ghost.scatter = false
			ghost.chase = true

func _on_frighten_timer_timeout() -> void:
	ghost_mode_cycle_node.paused = false
	for child in ghosts_node.get_children():
		child.is_frightened = false
		child.is_last_2_second = false
		child.adjust_animation()
	check_cruise_elroy()

func _on_blink_timer_timeout() -> void:
	for child in ghosts_node.get_children():
		if child.is_frightened == true:
			child.is_last_2_second = true
			child.adjust_animation()

func frighten_ghosts():
	var frighten_time_array := [6.0, 5.0, 4.0, 3.0, 2.0, 5.0, 2.0, 2.0, 1.0, 1.0, 1.0, 1.0, 1.0]
	if frighten_time_array.size() > Globals.game_level-1: # after level 14, ghost will not afraid
		ghost_mode_cycle_node.paused = true
		frighten_timer_node.start(frighten_time_array[Globals.game_level-1])
		blink_timer_node.start(max(frighten_time_array[Globals.game_level-1] -2, 0.001))
	for child in ghosts_node.get_children():
		if frighten_time_array.size() > Globals.game_level-1: # after level 14, ghost will not afraid
			child.is_frightened = true
			child.is_last_2_second = false
		child.change_direction(Globals.get_reverse_direction(child.direction))
		child.adjust_animation()

func blink_power_pellets():
	for child in power_pellets_node.get_children():
		child.play_animation()

func stop_power_pellets():
	for child in power_pellets_node.get_children():
		child.stop_animation()

func level_ended():
	level_end = true
	Globals.is_game_ended = true
	Globals.is_game_paused = true
	Globals.game_level += 1
	Globals.pellets_eaten = 0
	Globals.pellets_eaten_string.clear()
	await maze_node.blink_maze()
	reborn(false)
	
	

func get_pacman_overlap() -> Array[CharacterBody2D]:
	var bodies: Array[CharacterBody2D] = []
	for ghost in ghosts_node.get_children():
		if pacman_node.is_overlapping_with(ghost):
			if Globals.cheat_activated == false:
				bodies.append(ghost)
	return bodies

func _ready() -> void:
	score_node.update_score(Globals.score)
	Globals.game_speed = min(1.0 + float(Globals.game_level-1) / 10, 2.0)
	#print("Game speed: " + str(Globals.game_speed))
	if Globals.pellets_eaten_string.size() > 0:
		for child in pellets_node.get_children():
			if Globals.pellets_eaten_string.has(child.name):
				child.queue_free()
		for child in power_pellets_node.get_children():
			if Globals.pellets_eaten_string.has(child.name):
				child.queue_free()
	Globals.is_game_ended = false
	Globals.is_game_paused = true
	check_cruise_elroy()
	check_ghost_spawn()
	sounds_node.play_start_sound()
	blink_power_pellets()
	draw_extra_life_icon()
	draw_last_eaten_fruits()

func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed:
		if event.keycode == KEY_ENTER:
			if Globals.is_game_ended == true and level_end == false:
				reborn(true)
		elif event.keycode == KEY_ESCAPE:
			pause_game()
		elif event.keycode == KEY_D:
			for ghost in ghosts_node.get_children():
				if ghost.is_frightened == true:
					print(ghost.name + " is in FRIGHTEN mode, Target is: " + str(ghost.get_target()), " Possible Directions: " + str(ghost.get_ghost_possible_direction()))
				elif ghost.cruise_elory == true:
					print(ghost.name + " is in CRUSE ELORY mode, Target is: " + str(ghost.get_target()), " Possible Directions: " + str(ghost.get_ghost_possible_direction()))
				elif ghost.chase == true and ghost.scatter == false:
					print(ghost.name + " is in CHASE mode, Target is: " + str(ghost.get_target()), " Possible Directions: " + str(ghost.get_ghost_possible_direction()))
				elif ghost.chase == false and ghost.scatter == true:
					print(ghost.name + " is in SCATTER mode, Target is: " + str(ghost.get_target()), " Possible Directions: " + str(ghost.get_ghost_possible_direction()))
		elif event.keycode == KEY_S:
			print("Score is: " + str(Globals.score))
		elif event.keycode == KEY_C:
			if Globals.cheat_activated == true:
				Globals.cheat_activated = false
				print("Cheat deactivated!")
			elif Globals.cheat_activated == false:
				Globals.cheat_activated = true
				print("Cheat activated!")
		elif event.keycode == KEY_F:
			if Globals.cheat_activated == true:
				print("frighten ghost")
				frighten_ghosts()
	

func _process(delta: float) -> void:
	if Globals.is_game_ended == false:
		var bodies := get_pacman_overlap()
		if bodies.size() > 0:
			for ghost in bodies:
				if ghost.is_died == false:
					if ghost.is_frightened == false: # öldün
							stop_power_pellets()
							Globals.is_game_ended = true
							Globals.is_game_just_ended = true
							sounds_node.play_death_sound()
							check_game_over()
					elif ghost.is_frightened == true: # yedin
						var score_add := 200 * pow(2, Globals.ghost_eaten_since_last_frighten)
						add_score(score_add)
						Globals.ghost_eaten_since_last_frighten += 1
						ghost.die()
		if Globals.pellets_eaten == 244:
			level_ended()

func draw_extra_life_icon():
	for child in extra_lifes_node.get_children():
		child.queue_free()
	for i in range(Globals.extra_life):
		var texture_node := TextureRect.new()
		texture_node.name = "extra_life_" + str(i+1)
		texture_node.texture = preload("res://assets/extra_life.png")
		extra_lifes_node.add_child(texture_node)

func draw_last_eaten_fruits():
	for child in last_eaten_fruits_node.get_children():
		child.queue_free()
	for i in range(1, 8):
		if Globals.last_fruit_eaten.size() >= i:
			var texture_node := TextureRect.new()
			texture_node.name = "last_eaten_fruit_" + str(i)
			print(texture_node.name)
			texture_node.texture = Globals.fruit_sprite[Globals.last_fruit_eaten[-i]]
			last_eaten_fruits_node.add_child(texture_node)
