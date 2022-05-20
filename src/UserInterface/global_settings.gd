extends Node

signal bloom_toggled(value)
signal brightness_updated(value)
signal mouse_sens_updated(value)

func toggle_fullscreen(value):
	OS.window_fullscreen = value
	Save.game_data.fullscreen_on = value
	Save.save_data()

func toggle_vsync(value):
	OS.vsync_enabled = value
	Save.game_data.vsync_on = value
	Save.save_data()

func toggle_bloom(value):
	emit_signal("bloom_toggled", value)
	Save.game_data.bloom_on = value
	Save.save_data()

func update_brightness(value):
	emit_signal("brightness_updated", value)
	Save.game_data.brightness = value
	Save.save_data()

func update_vol(index, vol):
	AudioServer.set_bus_volume_db(index, vol)
	if index == 0:
		Save.game_data.master_vol = vol
	elif index == 1:
		Save.game_data.music_vol = vol
	elif index == 2:
		Save.game_data.sfx_vol = vol
	Save.save_data()

func update_mouse_sens(value):
	emit_signal("mouse_sens_updated", value)
	Save.game_data.mouse_sens = value
	Save.save_data()

func set_keybinds():
	for key in Save.keybinds.keys():
		var value = Save.keybinds[key]
		var actionlist = InputMap.get_action_list(key)
		if !actionlist.empty():
			# Erase the first key of the InputMap
			InputMap.action_erase_event(key, actionlist[0])
		if value != null:
			var new_key = InputEventKey.new()
			new_key.set_scancode(value)
			InputMap.action_add_event(key, new_key)

func write_config():
	Save.save_keys()
