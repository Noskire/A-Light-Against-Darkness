extends Node

signal time_updated
signal player_died
signal fire_updated

var best_time = -1.0 setget set_best_time
var time = 0.0 setget set_time
var fire_strenght = 0.1 setget set_fire_strenght
var deaths: = 0 setget set_deaths

# Modified the vars without the set_
func reset() -> void:
	# best_time = -1.0
	time = 0.0
	fire_strenght = 0.1
	deaths = 0

# PlayerData.x += 1
# set_x will receive value = 1 (0 + 1)
# but it'll NOT change the var score
# this it up to you

func set_best_time(value: float) -> void:
	best_time = value
	emit_signal("time_updated")

func set_time(value: float) -> void:
	time = value
	emit_signal("time_updated")

func set_fire_strenght(value: float) -> void:
	fire_strenght = value
	emit_signal("fire_updated")

func set_deaths(value: int) -> void:
	deaths = value
	emit_signal("player_died")
