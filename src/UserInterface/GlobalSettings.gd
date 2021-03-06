extends Node

signal bloom_toggled(value)
signal brightness_updated(value)
signal achievement_unlocked(value)

func toggle_fullscreen(value):
	OS.window_fullscreen = value
	Save.game_data.fullscreen_on = value
	Save.save_data()

func toggle_bloom(value):
	emit_signal("bloom_toggled", value)
	Save.game_data.bloom_on = value
	Save.save_data()

func toggle_vsync(value):
	OS.set_use_vsync(value)
	Save.game_data.vsync_on = value
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

func update_best_time(value) -> bool:
	if Save.score.best_time < 0 or value < Save.score.best_time:
		Save.score.best_time = value
		Save.save_score()
		
		if value <= 120:
			update_achievement("Speedrunner")
		
		return true
	return false

func get_level_light(index) -> float:
	match index:
		1:
			return Save.score.l01_torch
		2:
			return Save.score.l02_torch
		3:
			return Save.score.l03_torch
		4:
			return Save.score.l04_torch
		5:
			return Save.score.l05_torch
		100: # EndScreen
			# Last level light
			return Save.score.l05_torch
	return 0.1

func get_level_time(index) -> float:
	match index:
		1:
			return Save.score.l01_time
		2:
			return Save.score.l02_time
		3:
			return Save.score.l03_time
		4:
			return Save.score.l04_time
		5:
			return Save.score.l05_time
		100: 
			# Sum of all levels
			return (Save.score.l01_time + Save.score.l02_time +
			Save.score.l03_time + Save.score.l04_time + Save.score.l05_time)
	return 0.0

func get_kills() -> int:
	# Sum of all levels
	return (Save.score.l01_kills + Save.score.l02_kills +
		Save.score.l03_kills + Save.score.l04_kills + Save.score.l05_kills)

func get_level_deaths(index) -> int:
	match index:
		1:
			return Save.score.l01_deaths
		2:
			return Save.score.l02_deaths
		3:
			return Save.score.l03_deaths
		4:
			return Save.score.l04_deaths
		5:
			return Save.score.l05_deaths
		100: 
			# Sum of all levels
			return (Save.score.l01_deaths + Save.score.l02_deaths +
			Save.score.l03_deaths + Save.score.l04_deaths + Save.score.l05_deaths)
	return 0

func update_level(index: int, light: float, time: float, kills: int, deaths: int):
	match index:
		1:
			if light == 0.1:
				Save.score.l01_torch = light
			elif light != 0 and light > Save.score.l01_torch:
				Save.score.l01_torch = light
			if time != 0 and (Save.score.l01_time == 0 or time < Save.score.l01_time):
				Save.score.l01_time = time
			Save.score.l01_kills = kills
			Save.score.l01_deaths += deaths
		2:
			if light == 0.1:
				Save.score.l02_torch = light
			elif light != 0 and light > Save.score.l02_torch:
				Save.score.l02_torch = light
			if time != 0 and (Save.score.l02_time == 0 or time < Save.score.l02_time):
				Save.score.l02_time = time
			Save.score.l02_kills = kills
			Save.score.l02_deaths += deaths
		3:
			if light == 0.1:
				Save.score.l03_torch = light
			elif light != 0 and light > Save.score.l03_torch:
				Save.score.l03_torch = light
			if time != 0 and (Save.score.l03_time == 0 or time < Save.score.l03_time):
				Save.score.l03_time = time
			Save.score.l03_kills = kills
			Save.score.l03_deaths += deaths
		4:
			if light == 0.1:
				Save.score.l04_torch = light
			elif light != 0 and light > Save.score.l04_torch:
				Save.score.l04_torch = light
			if time != 0 and (Save.score.l04_time == 0 or time < Save.score.l04_time):
				Save.score.l04_time = time
			Save.score.l04_kills = kills
			Save.score.l04_deaths += deaths
		5:
			if light == 0.1:
				Save.score.l05_torch = light
			elif light != 0 and light > Save.score.l05_torch:
				Save.score.l05_torch = light
			if time != 0 and (Save.score.l05_time == 0 or time < Save.score.l05_time):
				Save.score.l05_time = time
			Save.score.l05_kills = kills
			Save.score.l05_deaths += deaths
	Save.save_score()
	if get_level_deaths(100) == 10:
		update_achievement("You Can DO IT!")

func update_achievement(name: String):
	if Save.achievements[name] == false:
		Save.achievements[name] = true
		var text
		match name:
			"One With the Darkness":
				text = (tr("ACH1NAME"))
			"One With the Light":
				text = (tr("ACH2NAME"))
			"Merciless Wretch!":
				text = (tr("ACH3NAME"))
			"Speedrunner":
				text = (tr("ACH4NAME"))
			"You Can DO IT!":
				text = (tr("ACH5NAME"))
			"Leave no Stone Unturned":
				text = (tr("ACH6NAME"))
		emit_signal("achievement_unlocked", text)
	
		var miss = 0
		for i in Save.achievements.keys():
			if Save.achievements[i] == false:
				miss += 1
		if miss == 1:
			Save.achievements["Leave no Stone Unturned"] = true
			emit_signal("achievement_unlocked", (tr("ACH6NAME")))
		Save.save_achievements()
