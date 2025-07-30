extends Node

@onready var game_node: Node2D = $".."
@onready var pacman_node: CharacterBody2D = $"../Pacman"

@onready var start_audio_node: AudioStreamPlayer = $StartAudio
@onready var eat1_audio_node: AudioStreamPlayer = $EatAudio1
@onready var eat2_audio_node: AudioStreamPlayer = $EatAudio2
@onready var death_audio_node: AudioStreamPlayer = $Death
@onready var siren_audio_node: AudioStreamPlayer = $Siren

var toggle := true

func play_start_sound():
	start_audio_node.play()

func play_eat_pellet_sound():
	var current = eat1_audio_node  if toggle else eat2_audio_node

	if not current.playing:
		if game_node.pellets_eaten % 2 == 1:
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

func _on_begininng_audio_finished() -> void:
	game_node.start_game()

func check_siren_sound() -> bool:
	var old_stream := siren_audio_node.stream
	var new_stream
	if game_node.pellets_eaten < 44:
		new_stream = preload("res://assets/sound/siren0.wav")
	elif game_node.pellets_eaten < 94:
		new_stream = preload("res://assets/sound/siren1.wav")
	elif game_node.pellets_eaten < 164:
		new_stream = preload("res://assets/sound/siren2.wav")
	elif game_node.pellets_eaten < 224:
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
	else:
		stop_siren()

func _ready() -> void:
	pass
