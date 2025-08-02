extends Assets

@onready var animation_node: AnimatedSprite2D = $AnimatedSprite2D
@onready var maze_node: Node2D = $"../../Maze"
@onready var pacman: CharacterBody2D = $"../../Pacman"
@onready var game_node: Node2D = $"../.."


const DEFAULT_GHOST_SPEED := 45.0

@export var color: String # red, orange, pink, cyan
@export var _color: Color
@export var ghost_speed := DEFAULT_GHOST_SPEED
@export var ghost_spawn_speed := 30.0
@export var did_spawned := false

var pixel_last_direction_change := Vector2.ZERO
var target := Vector2.ZERO

var scatter := true
var chase := false
var is_frightened := false
var is_last_2_second := false

var is_died := false
var cruise_elory := false

var is_spawning := false
var is_spawning_just_started := false
var is_spawning_just_ended := false
var spawn_x := 112.0
var spawn_y := 92.0

var zero_index := 0

func enter_cruise_elory(level: int):
	if is_frightened == false:
		adjust_animation()
		if level == 0:
			cruise_elory = false
			ghost_speed = DEFAULT_GHOST_SPEED
		elif level == 1:			
			cruise_elory = true
			ghost_speed = DEFAULT_GHOST_SPEED + 5
		elif level == 2:
			cruise_elory = true
			ghost_speed = DEFAULT_GHOST_SPEED + 10
	else:
		ghost_speed = DEFAULT_GHOST_SPEED

func returned_ghost_house():
	is_died = false
	is_spawning = false
	did_spawned = false
	pixel_last_direction_change = Vector2(0, 0)
	spawn_ghost()
	adjust_animation()
	game_node.check_cruise_elroy()

func die():
	is_died = true
	is_frightened = false
	is_last_2_second = false
	maze_node.open_ghost_gate(self)
	enter_cruise_elory(0)

func spawn_ghost():
	is_spawning_just_started = true

func adjust_animation(is_last_2_second := is_last_2_second, is_frightened := is_frightened, color := color, direction := direction):
	var current_animation_name := animation_node.animation
	if Globals.is_game_paused == false and Globals.is_game_ended == false:
		animation_node.speed_scale = Globals.game_speed
		if is_frightened == false and is_last_2_second == false and is_died == false:
				animation_node.set_animation(color + "_" + ("cruise_elroy_" if cruise_elory else "") + Globals.direction_string[direction if direction != Vector2.ZERO else Vector2.LEFT])
		elif is_frightened == true and is_last_2_second == false and is_died == false:
			animation_node.set_animation("frightened")
		elif is_frightened == true and is_last_2_second == true and is_died == false:
			animation_node.set_animation("frightened_blink")
		elif is_died == true:
			animation_node.set_animation("eye_" + Globals.direction_string[direction if direction != Vector2.ZERO else Vector2.LEFT])
		
		if current_animation_name != animation_node.animation:
			animation_node.play()
	else:
		animation_node.stop()

func get_ghost_possible_direction() -> Array[Vector2]:
	var possible: Array[Vector2] = []
	for next_direction in Globals.directions:
		if can_move(next_direction * 4):
			possible.append(next_direction)
	if direction != Vector2.ZERO:
		#if name == "Shadow":
			#print("Direction: " + Globals.direction_string[direction] + " Reverse direction: " + Globals.direction_string[Globals.get_reverse_direction(direction)])
		var index := possible.find(Globals.get_reverse_direction(direction))
		if index != -1:
			possible.remove_at(index)
	return possible

func _ready() -> void:
	animation_node.play(color + "_" + Globals.direction_string[direction])
	animation_node.stop()
	start_move(direction, ghost_speed)

func _process(delta: float) -> void:
	if cruise_elory == true:
		chase = true
		scatter = false
	adjust_animation()

func change_direction(next_direction := next_direction):
	direction = next_direction
	pixel_last_direction_change = position

func _physics_process(delta: float) -> void:
	if Globals.is_game_paused == false and Globals.is_game_ended == false:
		if is_spawning_just_started == true:
			maze_node.open_ghost_gate(self)
			is_spawning = true
			is_spawning_just_started = false
		
		elif is_spawning_just_ended == true:
			zero_index = 0
			maze_node.close_ghost_gate(self)
			is_spawning = false
			is_spawning_just_ended = false
			did_spawned = true
		
		elif is_spawning == true:
			if position.x != spawn_x:
				if position.x > spawn_x:
					direction = Vector2.LEFT
				elif position.x < spawn_x:
					direction = Vector2.RIGHT
				position.x = move_toward(position.x, spawn_x, ghost_spawn_speed * delta)
			elif position.y != spawn_y:
				if position.y > spawn_y:
					direction = Vector2.UP
				elif position.y < spawn_y:
					direction = Vector2.DOWN
				position.y = move_toward(position.y, spawn_y, ghost_spawn_speed * delta)
			else:
				is_spawning_just_ended = true
			
			
			
		
		
		
		elif is_spawning == false and did_spawned == true: # change direction
			move_and_slide()
			
			var possible := get_ghost_possible_direction()
			var flag := false
			
			if possible.size() > 1 and is_frightened == false:
				target = get_target()
				if target != Vector2.ZERO:
					flag = find_best_way(position, target, possible)
					#if is_died == true:
						#print("Position: " + str(position) + " Target: " + str(target))
			if flag == true:
				#print(Globals.direction_string[next_direction])
				pass
			
			elif (flag == false and chase == true) or (flag == false and scatter == true) or is_frightened == true:
				if possible.size() >= 1:
					next_direction = possible[randi() % possible.size()]
			
			if velocity == Vector2.ZERO: # sıkışmaması için
				zero_index += 1
				if zero_index >= 15:
					zero_index = 0
					next_direction = Globals.get_reverse_direction(direction)
					pixel_last_direction_change = Vector2(0, 0)
			
			
			if next_direction != direction and (abs(position.x - pixel_last_direction_change.x) > 4 or abs(position.y - pixel_last_direction_change.y) > 4):
				change_direction()
			
			
			
			if can_move(direction * 0.1):
				var temp_speed := ghost_speed
				if is_in_tunnel == true:
					temp_speed /= 2.5 # tunnel speed
				if is_frightened == true:
					temp_speed /= 2.0 # frighen speed
				if is_died == true:
					temp_speed *= 2.0
				set_asset_velocity(direction, temp_speed)
			else:
				velocity = Vector2.ZERO
			
		elif is_spawning == false and did_spawned == false: # ghost house
			move_and_slide()
			if can_move(direction * 0.1):
				set_asset_velocity(direction, ghost_speed)
			else:
				direction = Globals.get_reverse_direction(direction)
	
	elif Globals.is_game_paused == true or Globals.is_game_ended == true:
		pass

func get_target() -> Vector2:
	var taget := Vector2.ZERO
	if is_died == true:
		target = Globals.GHOST_HOUSE_POSITION
	elif chase == false and scatter == true:
		target = maze_node.get_node("Patrol/" + name).position
	elif chase == true and scatter == false:
		match name:
			"Shadow": # red
				if chase == true and scatter == false:
					target = pacman.get_local_position()
			"Speedy": # pink
				if chase == true and scatter == false: # 4 block ahead
					target = pacman.get_local_position() + pacman.direction * 32
			"Bashful": # cyan
				if chase == true and scatter == false: # 2
					var blinky_pos: Vector2 = $"../Shadow".position
					var pacman_pos: Vector2 = pacman.get_local_position()
					target = 2 * (pacman_pos + pacman.direction * 16 - blinky_pos) + blinky_pos
			"Pokey": # orange
				if chase == true and scatter == false: # target pacman until distance is longer than 8 block
					var pacman_pos: Vector2 = pacman.get_local_position()
					if abs(position.x - pacman_pos.x) + abs(position.y - pacman_pos.y) > 64: # 8
						target = pacman.get_local_position()
					else: # target left-bottom corner
						target = maze_node.get_node("Patrol/" + name).position
	return target
		

func find_best_way(from: Vector2, to: Vector2, possible: Array[Vector2]) -> bool:
	var flag := false
	if possible.size() > 1:
		if position.y > target.y and position.x > target.x: # target is upper-left
			if possible.has(Vector2.UP) and possible.has(Vector2.LEFT):
				if position.y - target.y > position.x - target.x: # y is longer than x
					next_direction = Vector2.UP
					flag = true
				elif position.y - target.y < position.x - target.x: # x is longer than y
					next_direction = Vector2.LEFT
					flag = true
				else: # same length select random
					next_direction = [Vector2.LEFT, Vector2.UP][randi() % 2]
					flag = true
			elif possible.has(Vector2.UP) and not possible.has(Vector2.LEFT): # can onlu move upper
				next_direction = Vector2.UP
				flag = true
			elif not possible.has(Vector2.UP) and possible.has(Vector2.LEFT): # an only move left
				next_direction = Vector2.LEFT
				flag = true
			else: # target is upper-left but neither can move left nor up
				next_direction = possible[randi() % possible.size()]
				flag = true
		
		elif position.y > target.y and position.x < target.x: # target is upper-right
			if possible.has(Vector2.UP) and possible.has(Vector2.RIGHT):
				if position.y - target.y > target.x - position.x: # y is longer than x
					next_direction = Vector2.UP
					flag = true
				elif position.y - target.y < target.x - position.x: # x is longer than y
					next_direction = Vector2.RIGHT
					flag = true
				else: # same length select random
					next_direction = [Vector2.RIGHT, Vector2.UP][randi() % 2]
					flag = true
			elif possible.has(Vector2.UP) and not possible.has(Vector2.RIGHT): # can onlu move upper
				next_direction = Vector2.UP
				flag = true
			elif not possible.has(Vector2.UP) and possible.has(Vector2.RIGHT): # an only move right
				next_direction = Vector2.RIGHT
				flag = true
			else: # target is upper-right but neither can move right nor up
				next_direction = possible[randi() % possible.size()]
				flag = true
		
		elif target.y > position.y and position.x > target.x: # target is down-left
			if possible.has(Vector2.DOWN) and possible.has(Vector2.LEFT):
				if target.y - position.y > position.x - target.x: # y is longer than x
					next_direction = Vector2.DOWN
					flag = true
				elif target.y - position.y < position.x - target.x: # x is longer than y
					next_direction = Vector2.LEFT
					flag = true
				else: # same length select random
					next_direction = [Vector2.LEFT, Vector2.DOWN][randi() % 2]
					flag = true
			elif possible.has(Vector2.DOWN) and not possible.has(Vector2.LEFT): # can onlu move down
				next_direction = Vector2.DOWN
				flag = true
			elif not possible.has(Vector2.DOWN) and possible.has(Vector2.LEFT): # an only move left
				next_direction = Vector2.LEFT
				flag = true
			else: # target is down-left but neither can move left nor down
				next_direction = possible[randi() % possible.size()]
				flag = true
		
		elif target.y > position.y and target.x > position.x: # target is down-right
			if possible.has(Vector2.DOWN) and possible.has(Vector2.RIGHT):
				if target.y - position.y > target.x - position.x: # y is longer than x
					next_direction = Vector2.DOWN
					flag = true
				elif target.y - position.y < target.x - position.x: # x is longer than y
					next_direction = Vector2.RIGHT
					flag = true
				else: # same length select random
					next_direction = [Vector2.RIGHT, Vector2.DOWN][randi() % 2]
					flag = true
			elif possible.has(Vector2.DOWN) and not possible.has(Vector2.RIGHT): # can onlu move down
				next_direction = Vector2.DOWN
				flag = true
			elif not possible.has(Vector2.DOWN) and possible.has(Vector2.RIGHT): # an only move right
				next_direction = Vector2.RIGHT
				flag = true
			else: # target is down-right but neither can move right nor down
				next_direction = possible[randi() % possible.size()]
				flag = true
		
		elif target.y == position.y and target.x > position.x: # target is right
			if possible.has(Vector2.RIGHT):
				next_direction = Vector2.RIGHT
				flag = true
			else:
				next_direction = possible[randi() % possible.size()]
				flag = true
		elif target.y == position.y and target.x < position.x: # target is left
			if possible.has(Vector2.LEFT):
				next_direction = Vector2.LEFT
				flag = true
			else:
				next_direction = possible[randi() % possible.size()]
				flag = true
		elif target.y > position.y and target.x == position.x: # target is down
			if possible.has(Vector2.DOWN):
				next_direction = Vector2.DOWN
				flag = true
			else:
				next_direction = possible[randi() % possible.size()]
				flag = true
		elif target.y < position.y and target.x == position.x: # target is up
			if possible.has(Vector2.UP):
				next_direction = Vector2.UP
				flag = true
			else:
				next_direction = possible[randi() % possible.size()]
				flag = true
		elif target.y == position.y and target.x == position.x: # at the target
			next_direction = possible[randi() % possible.size()]
			flag = true
	return flag
