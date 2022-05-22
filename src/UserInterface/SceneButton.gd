extends Button

var scene_path

func _ready():
	var err
	err = self.connect("button_up", self, "_on_btn_up")
	if err != OK:
		print("Error Connect button_up")

func _on_btn_up():
	var err
	err = get_tree().change_scene(scene_path)
	if err != OK:
		print("Error Continue Button Scene Change")
