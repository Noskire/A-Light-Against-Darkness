extends Control

onready var screen = self
onready var label = $Label
onready var timer = $Timer

func _ready():
	var err
	err = GlobalSettings.connect("achievement_unlocked", self, "_on_achievement_unlocked")
	if err != OK:
		print("Error Connect achievement_unlocked")

func _on_achievement_unlocked(value):
	if timer.is_stopped():
		label.set_text(tr("ACHUNLOCK") + "\n— " + value)
		screen.set_visible(true)
	else:
		label.text = str(label.text, "\n— ", value)
	timer.start()

func _on_Timer_timeout():
	label.text = ""
	screen.set_visible(false)
