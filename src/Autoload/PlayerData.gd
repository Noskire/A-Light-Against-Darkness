extends Node

signal time_updated
signal player_died

var time: = -1.0 setget set_time
var best_time = -1.0
var deaths: = 0 setget set_deaths

# Modified the vars without the set_
func reset() -> void:
	time = 0
	deaths = 0

# PlayerData.score += 1
# set_score will receive value = 1 (0 + 1)
# but it'll NOT change the var score
# this it up to you

func set_time(value: float) -> void:
	time = value
	
	# When call END_SCREEN
	if time >= 0:
		if best_time < 0 || time < best_time:
			best_time = time
	# Move it later
	
	emit_signal("time_updated")

func set_deaths(value: int) -> void:
	deaths = value
	emit_signal("player_died")
