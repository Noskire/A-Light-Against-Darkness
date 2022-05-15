tool
extends Control

onready var time: Label = get_node("Timer")
# onready var best_time: Label = get_node("BestTime")
onready var deaths: Label = get_node("Deaths")

export(String, FILE) var next_scene_path: = ""

func _get_configuration_warning() -> String:
	return "The next scene path can't be empty" if next_scene_path == "" else ""

func _ready() -> void:
	$Menu/MenuButton.grab_focus()
	if PlayerData.best_time < 0 || PlayerData.time < PlayerData.best_time:
		PlayerData.best_time = PlayerData.time
		time.text = "Time: %ss (New Highscore)" % PlayerData.time
	else:
		time.text = "Time: %ss" % PlayerData.time
	deaths.text = "Deaths: %s" % PlayerData.deaths

func _on_MenuButton_button_up():
	# "Retry" and then call MainScreen
	PlayerData.time = -1.0
	get_tree().paused = false
	
	var err
	err = get_tree().change_scene(next_scene_path)
	if err != OK:
		print("Error" + "MainMenuButton")

func _on_QuitButton_button_up():
	get_tree().quit()
