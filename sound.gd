extends Node

@onready var game_node: Node2D = $".."
@onready var pacman_node: CharacterBody2D = $"../Pacman"

@onready var start_audio_node: AudioStreamPlayer = $StartAudio
@onready var eat1_audio_node: AudioStreamPlayer = $EatAudio1
@onready var eat2_audio_node: AudioStreamPlayer = $EatAudio2
@onready var death_audio_node: AudioStreamPlayer = $Death
@onready var siren_audio_node: AudioStreamPlayer = $Siren
@onready var eat_fruit_audio_node: AudioStreamPlayer = $EatFruit
@onready var eyes_audio_node: AudioStreamPlayer = $Eyes

var toggle := true

func play_start_sound():
	start_audio_node.play()

func play_eat_fruit_sound():
	eat_fruit_audio_node.play()

func play_eat_pellet_sound():
	var current = eat1_audio_node  if toggle else eat2_audio_node

	if not current.playing:
		if Globals.pellets_eaten % 2 == 1:
			current.stream = preload("res://assets/sound/eat_dot_0.wav")
		else:
			current.stream = preload("res://assets/sound/eat_dot_1.wav")
		current.play()
		toggle = !toggle

func play_siren():
	siren_audio_node.play()

func stop_siren():
	siren_audio_node.stop()

func play_death_sound():
	death_audio_node.stream = preload("res://assets/sound/death_0.wav")
	death_audio_node.play()
	await death_audio_node.finished
	death_audio_node.stream = preload("res://assets/sound/death_1.wav")
	death_audio_node.play()
	await death_audio_node.finished
	death_audio_node.play()
	await death_audio_node.finished

func play_eye_sound():
	eyes_audio_node.play()

func stop_eye_sound():
	eyes_audio_node.stop()

func _on_begininng_audio_finished() -> void:
	game_node.start_game()

func check_eye_sound() -> bool:
	var old_stream := eyes_audio_node.stream
	var new_stream
	if game_node.check_any_ghost_died() == true:
		new_stream = preload("res://assets/sound/eyes.wav")
	else:
		new_stream = null
	
	if old_stream == new_stream:
		return false
	else:
		eyes_audio_node.stream = new_stream
		return true
		

func check_siren_sound() -> bool:
	var old_stream := siren_audio_node.stream
	var new_stream
	if Globals.ghost_eaten_since_last_frighten < 4 and game_node.frighten_timer_node.is_stopped() == false:
		new_stream = preload("res://assets/sound/fright.wav")
	else:
		if Globals.pellets_eaten < 44:
			new_stream = preload("res://assets/sound/siren0.wav")
		elif Globals.pellets_eaten < 94:
			new_stream = preload("res://assets/sound/siren1.wav")
		elif Globals.pellets_eaten < 164:
			new_stream = preload("res://assets/sound/siren2.wav")
		elif Globals.pellets_eaten < 224:
			new_stream = preload("res://assets/sound/siren3.wav")
		else:
			new_stream = preload("res://assets/sound/siren4.wav")
	
	if old_stream == new_stream:
		return false
	else:
		siren_audio_node.stream = new_stream
		return true

func _process(delta: float) -> void:
	if Globals.is_game_paused == false and Globals.is_game_ended == false:
		if check_siren_sound():
			play_siren()
		if check_eye_sound():
			play_eye_sound()
	else:
		stop_siren()
		stop_eye_sound()
	
	

func _ready() -> void:
	pass
