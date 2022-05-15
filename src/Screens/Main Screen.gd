tool
extends Control

export(String, FILE) var next_scene_path: = ""

func _get_configuration_warning() -> String:
	return "The next scene path can't be empty" if next_scene_path == "" else ""

func _ready():
	$Menu/PlayButton.grab_focus()

func _on_PlayButton_button_up():
	var err
	err = get_tree().change_scene(next_scene_path)
	if err != OK:
		print("Error" + "Main Screen Play Button")

func _on_QuitButton_button_up():
	get_tree().quit()
