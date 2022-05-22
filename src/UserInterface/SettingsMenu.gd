extends Popup

onready var tab_container = $Bg/TabC

# Video Settings
onready var display_options_btn = $Bg/TabC/Video/MarginC/Grid/DisplayOption
onready var bloom_btn = $Bg/TabC/Video/MarginC/Grid/BloomBtn
onready var brightness_value = $Bg/TabC/Video/MarginC/Grid/HBox/BrightnessValue
onready var brightness_slide = $Bg/TabC/Video/MarginC/Grid/HBox/BrightnessSlider

# Audio Settings
onready var master_value = $Bg/TabC/Audio/MarginC/Grid/HBox1/MasterVolValue
onready var master_slide = $Bg/TabC/Audio/MarginC/Grid/HBox1/MasterVolSlider
onready var music_value = $Bg/TabC/Audio/MarginC/Grid/HBox2/MusicVolValue
onready var music_slide = $Bg/TabC/Audio/MarginC/Grid/HBox2/MusicVolSlider
onready var sfx_value = $Bg/TabC/Audio/MarginC/Grid/HBox3/SfxVolValue
onready var sfx_slide = $Bg/TabC/Audio/MarginC/Grid/HBox3/SfxVolSlider

# Keybind Setting
onready var keybind_grid = $Bg/TabC/Keybind/MarginC/Grid
onready var button_script = load("res://src/UserInterface/KeyButton.gd")
var buttons = {}
var keybinds

func _ready():
	display_options_btn.select(1 if Save.game_data.fullscreen_on else 0)
	GlobalSettings.toggle_fullscreen(Save.game_data.fullscreen_on)
	bloom_btn.pressed = Save.game_data.bloom_on
	brightness_slide.value = Save.game_data.brightness
	
	master_slide.value = Save.game_data.master_vol
	music_slide.value = Save.game_data.music_vol
	sfx_slide.value = Save.game_data.sfx_vol
	
	GlobalSettings.set_keybinds()
	keybinds = Save.keybinds.duplicate()
	for key in keybinds.keys():
		var label = Label.new()
		var button = Button.new()
		
		label.set_h_size_flags(Control.SIZE_EXPAND_FILL)
		button.set_h_size_flags(Control.SIZE_EXPAND)
		button.set_h_size_flags(Control.SIZE_SHRINK_END)
		
		label.text = key
		
		var button_value = keybinds[key]
		if button_value != null:
			button.text = OS.get_scancode_string(button_value)
		else:
			button.text = "Unassigned"
		
		button.set_script(button_script)
		button.key = key
		button.value = button_value
		button.menu = self
		button.toggle_mode = true
		button.focus_mode = Control.FOCUS_NONE
		
		keybind_grid.add_child(label)
		keybind_grid.add_child(button)
		
		buttons[key] = button

func _on_DisplayOption_item_selected(index):
	GlobalSettings.toggle_fullscreen(true if index == 1 else false)

func _on_BloomBtn_toggled(button_pressed):
	GlobalSettings.toggle_bloom(button_pressed)

func _on_BrightnessSlider_value_changed(value):
	GlobalSettings.update_brightness(value)
	brightness_value.text = str(Save.game_data.brightness)

func _on_MasterVolSlider_value_changed(value):
	GlobalSettings.update_vol(0, value)
	master_value.text = str(Save.game_data.master_vol)

func _on_MusicVolSlider_value_changed(value):
	GlobalSettings.update_vol(1, value)
	music_value.text = str(Save.game_data.music_vol)

func _on_SfxVolSlider_value_changed(value):
	GlobalSettings.update_vol(2, value)
	sfx_value.text = str(Save.game_data.sfx_vol)

func change_bind(key, value):
	keybinds[key] = value
	for k in keybinds.keys():
		if k != key and value != null and keybinds[k] == value:
			keybinds[k] = null
			buttons[k].value = null
			buttons[k].text = "Unassigned"

func _on_TabC_tab_selected(tab):
	if tab == 3:
		tab_container.current_tab = 0
		self.visible = false

func _on_Reset_button_up():
	keybinds = Save.standard_keybinds.duplicate()
	Save.keybinds = Save.standard_keybinds.duplicate()
	for k in keybinds.keys():
		buttons[k].value = keybinds[k]
		buttons[k].text = OS.get_scancode_string(keybinds[k])
	GlobalSettings.set_keybinds()
	GlobalSettings.write_config()

func _on_Save_button_up():
	Save.keybinds = keybinds.duplicate()
	GlobalSettings.set_keybinds()
	GlobalSettings.write_config()
