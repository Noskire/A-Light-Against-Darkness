extends KinematicBody2D

onready var torch: Light2D = get_node("Torch")

const TORCH_COLOR = Color("#FFB075")
const TORCH_UNLIT = Color("#000000")
const MAX_TORCH_STRENGHT = 30.0
const PLAYER_SPEED = 500.0
const SLOW_FACTOR = 2.0
const DAMAGE_MULTIPLIER = 5.0

var move_speed = 500.0
var slowed = false

# Torch var
var current_color = TORCH_COLOR
var fire_strenght = 10.0
var current_time = PlayerData.time
var weight = 1.0

#Unused
# var total_time = 30.0

func _physics_process(delta: float) -> void:
	# Aim and Move
	var direction: = get_direction()
	direction = move_and_slide(direction * move_speed)
	look_at(get_global_mouse_position())
	
	# Update Clock
	current_time += delta
	PlayerData.time = int (current_time)
	
	# Die :(
	if fire_strenght <= 0:
		die()

func get_direction() -> Vector2:
	var out: = Vector2(
		Input.get_action_strength("move_right") - Input.get_action_strength("move_left"),
		Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	)
	out = out.normalized()
	return out

func change_speed() -> void:
	slowed = not slowed
	if slowed:
		move_speed = PLAYER_SPEED / SLOW_FACTOR
	else:
		move_speed = PLAYER_SPEED

func relight_torch() -> void:
	fire_strenght = MAX_TORCH_STRENGHT
	change_torch_strenght()

func take_damage() -> void:
	fire_strenght -= DAMAGE_MULTIPLIER
	change_torch_strenght()

func change_torch_strenght() -> void:
	weight = fire_strenght / MAX_TORCH_STRENGHT
	current_color = TORCH_COLOR.linear_interpolate(TORCH_UNLIT, (1 - weight))
	torch.color = current_color

func die() -> void:
	PlayerData.deaths += 1
	queue_free()
