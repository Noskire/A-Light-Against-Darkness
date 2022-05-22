tool
extends Control

onready var time: Label = get_node("Timer")
onready var deaths: Label = get_node("Deaths")

export(String, FILE) var next_scene_path: = ""

func _get_configuration_warning() -> String:
	return "The next scene path can't be empty" if next_scene_path == "" else ""

func _ready() -> void:
	$Menu/MenuButton.grab_focus()
	var current_scene_id = 100
	var fire_strenght = GlobalSettings.get_level_light(current_scene_id)
	print("EndScreen: ", fire_strenght)
	var total_time = GlobalSettings.get_level_time(current_scene_id)
	var total_deaths = GlobalSettings.get_level_deaths(current_scene_id)
	if GlobalSettings.update_best_time(total_time):
		time.text = "Time: %ss (New Highscore)" % total_time
	else:
		time.text = "Time: %ss" % total_time
	deaths.text = "Deaths: %s" % total_deaths

func _on_MenuButton_button_up():
	# "Retry" and then call MainScreen
	get_tree().paused = false
	
	var err
	err = get_tree().change_scene(next_scene_path)
	if err != OK:
		print("Error" + "MainMenuButton")

func _on_QuitButton_button_up():
	get_tree().quit()
