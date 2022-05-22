extends Popup

onready var tab_container = $Bg/TabC
onready var levels_grid = $Bg/TabC/Achievements/MarginC/Grid

var achiev

func _ready():
	achiev = Save.achievements.duplicate()
	for i in achiev.keys():
		var label = Label.new()
		label.set_h_size_flags(Control.SIZE_EXPAND_FILL)
		label.set_align(Label.ALIGN_CENTER)
		label.set_v_size_flags(Control.SIZE_EXPAND_FILL)
		if achiev[i]:
			label.text = i
			label.set_uppercase(true)
		else:
			match i:
				"One With the Darkness":
					label.text = "-✅ Complete the game without lit your torch -"
				"One With the Light":
					label.text = "-✅ Don't scare away any animals -"
				"Merciless Wretch!":
					label.text = "-✅ What's yours is yours! -"
				"Speedrunner":
					label.text = "-✅ Beat the game in less than 120 seconds -"
				"You Can DO IT!":
					label.text = "-✅ Die 10 times and keep trying -"
				"Leave no Stone Unturned":
					label.text = "-✅ Complete it all -"
		levels_grid.add_child(label)

func _on_TabC_tab_selected(tab):
	if tab == 1:
		tab_container.current_tab = 0
		self.visible = false
