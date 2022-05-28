extends Popup

onready var tab_container = $Bg/TabC
onready var levels_grid = $Bg/TabC/ACHIEVEMENTS/MarginC/Grid

var achiev

func _ready():
	achiev = Save.achievements.duplicate()
	for i in achiev.keys():
		var label = Label.new()
		match i:
			"One With the Darkness":
				if achiev[i]:
					label.set_text(tr("ACH1NAME"))
					label.set_uppercase(true)
				else:
					label.set_text(tr("ACH1DESC"))
			"One With the Light":
				if achiev[i]:
					label.set_text(tr("ACH2NAME"))
					label.set_uppercase(true)
				else:
					label.set_text(tr("ACH2DESC"))
			"Merciless Wretch!":
				if achiev[i]:
					label.set_text(tr("ACH3NAME"))
					label.set_uppercase(true)
				else:
					label.set_text(tr("ACH3DESC"))
			"Speedrunner":
				if achiev[i]:
					label.set_text(tr("ACH4NAME"))
					label.set_uppercase(true)
				else:
					label.set_text(tr("ACH4DESC"))
			"You Can DO IT!":
				if achiev[i]:
					label.set_text(tr("ACH5NAME"))
					label.set_uppercase(true)
				else:
					label.set_text(tr("ACH5DESC"))
			"Leave no Stone Unturned":
				if achiev[i]:
					label.set_text(tr("ACH6NAME"))
					label.set_uppercase(true)
				else:
					label.set_text(tr("ACH6DESC"))
		label.set_h_size_flags(Control.SIZE_EXPAND_FILL)
		label.set_align(Label.ALIGN_CENTER)
		label.set_v_size_flags(Control.SIZE_EXPAND_FILL)
		levels_grid.add_child(label)

func _on_TabC_tab_selected(tab):
	if tab == 1:
		tab_container.current_tab = 0
		self.visible = false
