extends Button

func _on_button_up():
	PlayerData.time = -1.0
	get_tree().paused = false
	var err
	err = get_tree().reload_current_scene()
	if err != OK:
		print("Error" + "reload_scene RetryButton")
