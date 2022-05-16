tool
extends Control

onready var scene_tree: = get_tree()
onready var time: Label = get_node("Timer")
onready var pause_overlay: ColorRect = get_node("PauseOverlay")
onready var pause_title: Label = get_node("PauseOverlay/Title")

export(String, FILE) var next_scene_path: = ""

const PAUSED_MESSAGE: = " Paused! "
const DIED_MESSAGE:   = "You died!"

var paused = false

func _get_configuration_warning() -> String:
	return "The next scene path can't be empty" if next_scene_path == "" else ""

func _ready() -> void:
	var err
	err = PlayerData.connect("player_died", self, "_on_PlayerData_player_died")
	if err != OK:
		print("Error PlayerData.connect player_died")

func update_interface(value: int) -> void:
	time.text = "Time: %ss" % value

func _on_PlayerData_player_died() -> void:
	pause(true)
	pause_title.text = DIED_MESSAGE

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("pause_game") and pause_title.text != DIED_MESSAGE:
		pause(!paused)
		scene_tree.set_input_as_handled()

func pause(value: bool) -> void:
	paused = value
	scene_tree.paused = value
	pause_overlay.visible = value
	if value:
		$PauseOverlay/Menu/MenuButton.grab_focus()
	else:
		pause_title.text = PAUSED_MESSAGE

func _on_MenuButton_button_up():
	# "Retry" and then call MainScreen
	PlayerData.time = -1.0
	scene_tree.paused = false
	
	var err
	err = scene_tree.change_scene(next_scene_path)
	if err != OK:
		print("Error change_scene MenuButton")

func _on_RetryButton_button_up():
	scene_tree.paused = false
	var err
	err = scene_tree.reload_current_scene()
	if err != OK:
		print("Error reload_scene RetryButton")

func _on_QuitButton_button_up():
	scene_tree.quit()
