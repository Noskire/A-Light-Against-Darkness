extends Control

onready var scene_tree: = get_tree()
onready var time: Label = get_node("Timer")
# onready var best_time: Label = get_node("BestTime")
# onready var deaths: Label = get_node("Deaths")
onready var pause_overlay: ColorRect = get_node("PauseOverlay")
onready var pause_title: Label = get_node("PauseOverlay/Title")

const PAUSED_MESSAGE: = " Paused! "
const DIED_MESSAGE:   = "You died!"

var paused: = false setget set_paused

func _ready() -> void:
	var err
	err = PlayerData.connect("time_updated", self, "update_interface")
	if err != OK:
		print("Error" + "PlayerData.connect time_updated")
	err = PlayerData.connect("player_died", self, "_on_PlayerData_player_died")
	if err != OK:
		print("Error" + "PlayerData.connect player_died")
	update_interface()

func update_interface() -> void:
	time.text = "Time: %ss" % PlayerData.time
	# best_time.text = "Best Time: %ss" % ("-" if PlayerData.best_time < 0 else PlayerData.best_time)
	# deaths.text = "Deaths: %s" % PlayerData.deaths

func _on_PlayerData_player_died() -> void:
	self.paused = true
	pause_title.text = DIED_MESSAGE

# self ensures that goes through the set_ funcion
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("pause_game") and pause_title.text != DIED_MESSAGE:
		self.paused = !paused
		scene_tree.set_input_as_handled()

func set_paused(value: bool) -> void:
	paused = value
	scene_tree.paused = value
	pause_overlay.visible = value
	if value == false:
		pause_title.text = PAUSED_MESSAGE
