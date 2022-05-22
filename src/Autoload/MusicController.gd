extends Node

var ambient_music = load("res://assets/sounds/Cave_Song.wav")

func _ready():
	play_music()

func play_music():
	$Music.stream = ambient_music
	$Music.play()

func _on_Music_finished():
	play_music()
