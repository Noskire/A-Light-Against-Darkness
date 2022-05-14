extends KinematicBody2D

onready var player: Node2D = get_parent().get_node("Player")
onready var tween_node = get_node("Tween")

export var charge_velocity = Vector2(300.0, 300.0)

# States
const IDLE = 0
const PREPARE = 1
const ATTACK = 2
const REST = 3
var state = IDLE

# Use a AnimationPlayer instead
const REST_TIME = 1.0
var rest_timer = REST_TIME

# Use a AnimationPlayer instead
const PREPARE_TIME = 1.2
var prepare_timer = PREPARE_TIME

var enemy_pos = Vector2()
var target_pos = Vector2()
var direction = Vector2()
var velocity = Vector2()

func _ready() -> void:
	# "Freeze" the enemy until the VisibilityEnabler2D be visible by the view
	set_physics_process(false)

func _physics_process(delta: float) -> void:
	if state in [IDLE, REST]:
		enemy_pos = get_global_position()
		look_at(player.position)
		direction = (player.position - enemy_pos).normalized()
	if state == IDLE: # and player.is_idle():
		go_to_state(PREPARE)
	elif state == PREPARE:
		prepare_timer -= delta
		if prepare_timer <= 0:
			go_to_state(ATTACK)
	elif state == REST:
		rest_timer -= delta
		if rest_timer <= 0:
			go_to_state(IDLE)

func go_to_state(new_state):
	state = new_state
	if new_state == REST:
		rest_timer = REST_TIME
	elif new_state == PREPARE:
		prepare_timer = PREPARE_TIME
		velocity = direction * charge_velocity
		target_pos = enemy_pos + velocity
	elif new_state == ATTACK:
		move_to(target_pos)

func move_to(target) -> void:
	tween_node.interpolate_property(self, "position", get_global_position(), target, 1.0, Tween.TRANS_CUBIC, Tween.EASE_OUT)
	tween_node.start()

func _on_Tween_tween_completed(_object, _key):
	go_to_state(REST)
