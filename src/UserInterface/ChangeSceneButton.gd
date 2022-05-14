tool
extends Button

export(String, FILE) var next_scene_path: = ""

func _get_configuration_warning() -> String:
	return "The next scene path can't be empty" if next_scene_path == "" else ""

func _on_button_up():
	var err
	err = get_tree().change_scene(next_scene_path)
	if err != OK:
		print("Error" + "ChangeSceneButton")
