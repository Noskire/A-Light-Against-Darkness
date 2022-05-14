extends KinematicBody2D

onready var torch: Light2D = get_node("Torch")
onready var enemy_detector: Area2D = $EnemyDetector

# Torch Stats
const TORCH_COLOR = Color("#FFB075")
const TORCH_UNLIT = Color("#000000")
const MAX_TORCH_STRENGHT = 30.0

var current_color = TORCH_COLOR
var fire_strenght = 20.0 # Also Player HP
var weight = 1.0 # 1 - Lit ~ 0 - Unlit

# Player Stats
const DAMAGE_MULTIPLIER = 5.0
const PLAYER_MAX_SPEED = 500.0
const SLOW_FACTOR = 2.0

var current_time = PlayerData.time
var move_speed = 500.0
var slowed = false

# Invulnerable after hit
const INVULNERABLE_TIME = 3.0
var invulnerable_timer = 0.0
var invulnerable = false

#Unused
# var total_time = 30.0

func _ready() -> void:
	change_torch_strenght()

func _physics_process(delta: float) -> void:
	# Aim and Move
	var direction = get_direction()
	direction = move_and_slide(direction * move_speed)
	look_at(get_global_mouse_position())
	
	# Update Clock
	current_time += delta
	PlayerData.time = int (current_time)
	
	# Update Invulnerable Timer
	if invulnerable:
		invulnerable_timer -= delta
		if invulnerable_timer <= 0:
			invulnerable = false
	
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
		move_speed = PLAYER_MAX_SPEED / SLOW_FACTOR
	else:
		move_speed = PLAYER_MAX_SPEED

func relight_torch() -> void:
	fire_strenght = MAX_TORCH_STRENGHT
	change_torch_strenght()

func take_damage() -> void:
	print(fire_strenght)
	if not invulnerable:
		fire_strenght -= DAMAGE_MULTIPLIER
		change_torch_strenght()
		invulnerable = true
		invulnerable_timer = INVULNERABLE_TIME

func change_torch_strenght() -> void:
	weight = fire_strenght / MAX_TORCH_STRENGHT
	current_color = TORCH_COLOR.linear_interpolate(TORCH_UNLIT, (1 - weight))
	torch.color = current_color

func die() -> void:
	PlayerData.deaths += 1
	queue_free()

func _on_EnemyDetector_body_entered(body):
	take_damage()
	# move_and_slide(body.direction * move_speed)
	# if body.global_position.y > stomp_area.global_position.y:
	# move_and_slide((body.global_position - enemy_detector.global_position) * move_speed * 10)
