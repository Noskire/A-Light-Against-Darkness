tool
extends Control

onready var scene_tree: = get_tree()
onready var canvas: CanvasModulate = get_parent().get_parent().get_node("CanvasModulate")
onready var died_timer: Timer = get_node("DiedTimer")
onready var time: Label = get_node("Timer")
onready var pause_overlay: ColorRect = get_node("PauseOverlay")
onready var pause_title: Label = get_node("PauseOverlay/Title")
onready var settings_menu = $SettingsMenu

export(String, FILE) var next_scene_path: = ""

const PAUSED_MESSAGE: = " Paused! "
const DIED_MESSAGE:   = "You died!"

func _get_configuration_warning() -> String:
	return "The next scene path can't be empty" if next_scene_path == "" else ""

func _ready() -> void:
	var err
	err = PlayerData.connect("player_died", self, "_on_PlayerData_player_died")
	if err != OK:
		print("Error PlayerData.connect player_died")

func update_interface(value: int) -> void:
	time.text = "Time: %ss" % value

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("Pause") and pause_title.text != DIED_MESSAGE:
		if pause_overlay.visible: # Paused
			scene_tree.paused = false
			pause_overlay.visible = false
			pause_title.text = PAUSED_MESSAGE
		else:
			scene_tree.paused = true
			pause_overlay.visible = true
			$PauseOverlay/Menu/MenuButton.grab_focus()
		scene_tree.set_input_as_handled()

func _on_PlayerData_player_died() -> void:
	$PauseOverlay/Menu/ResumeButton.visible = false
	pause_title.text = DIED_MESSAGE
	scene_tree.paused = true
	canvas.get_darker()
	died_timer.start()

func _on_DiedTimer_timeout():
	pause_overlay.visible = true
	pause_overlay.color.a = 0
	$PauseOverlay/Menu/MenuButton.grab_focus()

func _on_ResumeButton_button_up():
	scene_tree.paused = false
	pause_overlay.visible = false

func _on_RetryButton_button_up():
	scene_tree.paused = false
	var err
	err = scene_tree.reload_current_scene()
	if err != OK:
		print("Error reload_scene RetryButton")

func _on_SettingsButton_button_up():
	settings_menu.popup_centered()

func _on_MenuButton_button_up():
	# "Retry" and then call MainScreen
	PlayerData.time = -1.0
	scene_tree.paused = false
	
	var err
	err = scene_tree.change_scene(next_scene_path)
	if err != OK:
		print("Error change_scene MenuButton")

func _on_QuitButton_button_up():
	scene_tree.quit()
