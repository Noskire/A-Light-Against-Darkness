extends Popup

onready var tab_container = $Bg/TabC

# Video Settings
onready var display_options_btn = $Bg/TabC/Video/MarginC/Grid/DisplayOption
onready var vsync_btn = $Bg/TabC/Video/MarginC/Grid/VSyncBtn
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

# Gameplay Setting
onready var mouse_sens_value = $Bg/TabC/Gameplay/MarginC/Grid/HBox/MouseSensValue
onready var mouse_sens_slide = $Bg/TabC/Gameplay/MarginC/Grid/HBox/MouseSensSlider

func _ready():
	display_options_btn.select(1 if Save.game_data.fullscreen_on else 0)
	GlobalSettings.toggle_fullscreen(Save.game_data.fullscreen_on)
	vsync_btn.pressed = Save.game_data.vsync_on
	bloom_btn.pressed = Save.game_data.bloom_on
	brightness_slide.value = Save.game_data.brightness
	
	master_slide.value = Save.game_data.master_vol
	music_slide.value = Save.game_data.music_vol
	sfx_slide.value = Save.game_data.sfx_vol
	
	mouse_sens_slide.value = Save.game_data.mouse_sens

func _on_DisplayOption_item_selected(index):
	GlobalSettings.toggle_fullscreen(true if index == 1 else false)

func _on_VSyncBtn_toggled(button_pressed):
	GlobalSettings.toggle_vsync(button_pressed)

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

func _on_MouseSensSlider_value_changed(value):
	GlobalSettings.update_mouse_sens(value)
	mouse_sens_value.text = str(value)

func _on_TabC_tab_selected(tab):
	if tab == 3:
		tab_container.current_tab = 0
		self.visible = false
