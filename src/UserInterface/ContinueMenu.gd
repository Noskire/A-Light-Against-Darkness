extends Popup

onready var tab_container = $Bg/TabC
onready var levels_grid = $Bg/TabC/Levels/MarginC/Grid
onready var button_script = load("res://src/UserInterface/SceneButton.gd")

var score

func _ready():
	var torch_score
	score = Save.score.duplicate()
	
	# Best Time
	var label_blank1 = Label.new()
	label_blank1.text = " "
	#levels_grid.add_child(label_blank1)
	var best_time = score.best_time
	var label_bt = Label.new()
	label_bt.set_h_size_flags(Control.SIZE_FILL)
	label_bt.set_align(Label.ALIGN_CENTER)
	label_bt.set_v_size_flags(Control.SIZE_FILL)
	label_bt.set_valign(Label.VALIGN_CENTER)
	if best_time < 0:
		label_bt.text = "Best Time so far:"
	else:
		label_bt.text = str("Best Time so far:\n", best_time, "s")
	label_bt.set_uppercase(true)
	levels_grid.add_child(label_bt)

	# First Level (Always Visible)
	var btn_l01 = Button.new()
	btn_l01.set_h_size_flags(Control.SIZE_FILL)
	btn_l01.set_v_size_flags(Control.SIZE_FILL)
	btn_l01.text = "LVL01"
	btn_l01.set_script(button_script)
	btn_l01.scene_path = "res://src/Levels/Level01.tscn"
	var lbl_l01 = Label.new()
	lbl_l01.set_h_size_flags(Control.SIZE_EXPAND_FILL)
	if GlobalSettings.get_level_time(1) != 0:
		if score.l01_torch == 0.1:
			torch_score = "Unlit!"
		else:
			torch_score = str(score.l01_torch, "/30")
		lbl_l01.text = str("- The Fall\n", "Torch Light: ", torch_score,
			"\nTime: ", score.l01_time, "s\nDeaths: ", score.l01_deaths)
	levels_grid.add_child(btn_l01)
	levels_grid.add_child(lbl_l01)
	
	# Second Level
	var btn_l02 = Button.new()
	btn_l02.set_h_size_flags(Control.SIZE_FILL)
	btn_l02.set_v_size_flags(Control.SIZE_FILL)
	btn_l02.text = "LVL02"
	btn_l02.set_script(button_script)
	btn_l02.scene_path = "res://src/Levels/Level02.tscn"
	var lbl_l02 = Label.new()
	lbl_l02.set_h_size_flags(Control.SIZE_EXPAND_FILL)
	if GlobalSettings.get_level_time(2 - 1) != 0:
		if score.l02_torch == 0.1:
			torch_score = "Unlit!"
		else:
			torch_score = str(score.l02_torch, "/30")
		lbl_l02.text = str("- Colony of Bats\n", "Torch Light: ", torch_score,
			"\nTime: ", score.l02_time, "s\nDeaths: ", score.l02_deaths)
	else:
		btn_l02.set_disabled(true)
		lbl_l02.text = str("- ???\nTorch Light: --/30\nTime: --s\nDeaths: --")
	levels_grid.add_child(btn_l02)
	levels_grid.add_child(lbl_l02)

	# Third Level
	var btn_l03 = Button.new()
	btn_l03.set_h_size_flags(Control.SIZE_FILL)
	btn_l03.set_v_size_flags(Control.SIZE_FILL)
	btn_l03.text = "LVL03"
	btn_l03.set_script(button_script)
	btn_l03.scene_path = "res://src/Levels/Level03.tscn"
	var lbl_l03 = Label.new()
	lbl_l03.set_h_size_flags(Control.SIZE_EXPAND_FILL)
	if GlobalSettings.get_level_time(3 - 1) != 0:
		if score.l03_torch == 0.1:
			torch_score = "Unlit!"
		else:
			torch_score = str(score.l03_torch, "/30")
		lbl_l03.text = str("- Whole Troupe\n", "Torch Light: ", torch_score,
			"\nTime: ", score.l03_time, "s\nDeaths: ", score.l03_deaths)
	else:
		btn_l03.set_disabled(true)
		lbl_l03.text = str("- ???\nTorch Light: --/30\nTime: --s\nDeaths: --")
	levels_grid.add_child(btn_l03)
	levels_grid.add_child(lbl_l03)

	# Fourth Level
	var btn_l04 = Button.new()
	btn_l04.set_h_size_flags(Control.SIZE_FILL)
	btn_l04.set_v_size_flags(Control.SIZE_FILL)
	btn_l04.text = "LVL04"
	btn_l04.set_script(button_script)
	btn_l04.scene_path = "res://src/Levels/Level04.tscn"
	var lbl_l04 = Label.new()
	lbl_l04.set_h_size_flags(Control.SIZE_EXPAND_FILL)
	if GlobalSettings.get_level_time(4 - 1) != 0:
		if score.l04_torch == 0.1:
			torch_score = "Unlit!"
		else:
			torch_score = str(score.l04_torch, "/30")
		lbl_l04.text = str("- Hidden Things\n", "Torch Light: ", torch_score,
			"\nTime: ", score.l04_time, "s\nDeaths: ", score.l04_deaths)
	else:
		btn_l04.set_disabled(true)
		lbl_l04.text = str("- ???\nTorch Light: --/30\nTime: --s\nDeaths: --")
	levels_grid.add_child(btn_l04)
	levels_grid.add_child(lbl_l04)

	# Fifth Level
	var btn_l05 = Button.new()
	btn_l05.set_h_size_flags(Control.SIZE_FILL)
	btn_l05.set_v_size_flags(Control.SIZE_FILL)
	btn_l05.text = "LVL05"
	btn_l05.set_script(button_script)
	btn_l05.scene_path = "res://src/Levels/Level05.tscn"
	var lbl_l05 = Label.new()
	lbl_l05.set_h_size_flags(Control.SIZE_EXPAND_FILL)
	if GlobalSettings.get_level_time(5 - 1) != 0:
		if score.l05_torch == 0.1:
			torch_score = "Unlit!"
		else:
			torch_score = str(score.l05_torch, "/30")
		lbl_l05.text = str("- Dilemma\n", "Torch Light: ", torch_score,
			"\nTime: ", score.l05_time, "s\nDeaths: ", score.l05_deaths)
	else:
		btn_l05.set_disabled(true)
		lbl_l05.text = str("- ???\nTorch Light: --/30\nTime: --s\nDeaths: --")
	levels_grid.add_child(btn_l05)
	levels_grid.add_child(lbl_l05)

func _on_TabC_tab_selected(tab):
	if tab == 1:
		tab_container.current_tab = 0
		self.visible = false
