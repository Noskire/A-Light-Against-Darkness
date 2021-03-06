tool
extends Control

onready var time: Label = get_node("MarginC/VBox/Timer")
onready var deaths: Label = get_node("MarginC/VBox/Deaths")
onready var menu: Button = get_node("MarginC/VBox/Menu/MenuButton")

export(String, FILE) var next_scene_path: = ""

func _get_configuration_warning() -> String:
	return "The next scene path can't be empty" if next_scene_path == "" else ""

func _ready() -> void:
	menu.grab_focus()
	var current_scene_id = 100
	var total_time = GlobalSettings.get_level_time(current_scene_id)
	var total_deaths = GlobalSettings.get_level_deaths(current_scene_id)
	if GlobalSettings.update_best_time(total_time):
		time.set_text(tr("LVTIME") + " %ss" % total_time + tr("NEWHIGHSCORE"))
	else:
		time.set_text(tr("LVTIME") + " %ss" % total_time)
	deaths.set_text(tr("LVDEATHS") + " %s" % total_deaths)
	
	var fire_strenght = GlobalSettings.get_level_light(current_scene_id)
	if fire_strenght == 0.1:
		GlobalSettings.update_achievement("One With the Darkness")
	var kills = GlobalSettings.get_kills()
	if kills == 0:
		GlobalSettings.update_achievement("One With the Light")

func _on_MenuButton_button_up():
	# "Retry" and then call MainScreen
	get_tree().paused = false
	
	var err
	err = get_tree().change_scene(next_scene_path)
	if err != OK:
		print("Error" + "MainMenuButton")

func _on_QuitButton_button_up():
	get_tree().quit()
