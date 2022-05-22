tool
extends Control

onready var settings_menu = $SettingsMenu
onready var continue_menu = $ContinueMenu

export(String, FILE) var next_scene_path: = ""

func _get_configuration_warning() -> String:
	return "The next scene path can't be empty" if next_scene_path == "" else ""

func _ready():
	$Menu/PlayButton.grab_focus()
	if GlobalSettings.get_level_time(1) != 0:
		$Menu/ContinueButton.disabled = false

func _on_PlayButton_button_up():
	var err
	err = get_tree().change_scene(next_scene_path)
	if err != OK:
		print("Error" + "Main Screen Play Button")

func _on_ContinueButton_button_up():
	continue_menu.popup_centered()

func _on_SettingsButton_button_up():
	settings_menu.popup_centered()

func _on_QuitButton_button_up():
	get_tree().quit()
