extends Node

signal time_updated
signal player_died

var best_time = -1.0 setget set_best_time
var time = 0.0 setget set_time
var deaths: = 0 setget set_deaths

# Modified the vars without the set_
func reset() -> void:
	# best_time = -1.0
	time = 0.0
	deaths = 0

# PlayerData.score += 1
# set_score will receive value = 1 (0 + 1)
# but it'll NOT change the var score
# this it up to you

func set_best_time(value: float) -> void:
	best_time = value
	emit_signal("time_updated")

func set_time(value: float) -> void:
	time = value
	emit_signal("time_updated")

func set_deaths(value: int) -> void:
	deaths = value
	emit_signal("player_died")
