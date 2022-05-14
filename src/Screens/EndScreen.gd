extends Control

onready var time: Label = get_node("Timer")
# onready var best_time: Label = get_node("BestTime")
onready var deaths: Label = get_node("Deaths")

func _ready() -> void:
	if PlayerData.best_time < 0 || PlayerData.time < PlayerData.best_time:
		PlayerData.best_time = PlayerData.time
		time.text = "Time: %ss (New Highscore)" % PlayerData.time
	else:
		time.text = "Time: %ss" % PlayerData.time
	deaths.text = "Deaths: %s" % PlayerData.deaths
