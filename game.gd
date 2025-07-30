extends Node2D

@onready var blink_timer_node: Timer = $BlinkTimer
@onready var frighten_timer_node: Timer = $FrightenTimer
@onready var ghost_mode_cycle_node: Timer = $GhostModeCycle
@onready var ghosts_node: Node2D = $Ghosts
@onready var extra_lifes_node: Container = $ExtraLifes

@onready var pacman_node: CharacterBody2D = $Pacman
@onready var shadow_node: CharacterBody2D = $Ghosts/Shadow
@onready var speedy_node: CharacterBody2D = $Ghosts/Speedy
@onready var bashful_node: CharacterBody2D = $Ghosts/Bashful
@onready var pokey_node: CharacterBody2D = $Ghosts/Pokey
@onready var power_pellets_node: Node2D = $PowerPellets
@onready var sounds_node: Node = $Sounds

var ghost_mode_index := 0
var ghost_mode_timer := [7.0, 20.0, 7.0, 20.0, 5.0]

var pellets_eaten := 0

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

func check_cruise_elroy():
	if pellets_eaten >= 230:
		shadow_node.enter_cruise_elory(2)
	elif pellets_eaten >= 220:
		shadow_node.enter_cruise_elory(1)
	else:
		shadow_node.enter_cruise_elory(0)

func check_ghost_spawn():
	if pellets_eaten == 6:
		speedy_node.spawn_ghost()
	elif pellets_eaten == 30:
		bashful_node.spawn_ghost()
	elif pellets_eaten == 60:
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
		child.is_last_2_second = true
		child.adjust_animation()

func frighten_ghosts():
	ghost_mode_cycle_node.paused = true
	frighten_timer_node.start(12.0  / Globals.game_speed)
	blink_timer_node.start(8.0 / Globals.game_speed)
	for child in ghosts_node.get_children():
		child.is_frightened = true
		child.is_last_2_second = false
		child.adjust_animation()

func blink_power_pellets():
	for child in power_pellets_node.get_children():
		child.play_animation()

func stop_power_pellets():
	for child in power_pellets_node.get_children():
		child.stop_animation()

func get_pacman_overlap() -> Array[CharacterBody2D]:
	var bodies: Array[CharacterBody2D] = []
	for ghost in ghosts_node.get_children():
		if pacman_node.is_overlapping_with(ghost):
			bodies.append(ghost)
	return bodies

func _ready() -> void:
	sounds_node.play_start_sound()
	blink_power_pellets()
	draw_extra_life_icon()

func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed:
		if event.keycode == KEY_ESCAPE:
			pause_game()

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
					elif ghost.is_frightened == true: # yedin
						ghost.die()
		if pellets_eaten == 244:
			Globals.is_game_ended = true
			Globals.is_game_paused = true

func draw_extra_life_icon():
	for i in range(Globals.extra_life):
		var texture_node := TextureRect.new()
		texture_node.name = "extra_life_" + str(i+1)
		texture_node.texture = preload("res://assets/extra_life.png")
		extra_lifes_node.add_child(texture_node)
