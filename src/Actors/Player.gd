extends KinematicBody2D

onready var ui_control: Control = get_parent().get_node("UserInterface/UserInterface")
onready var torch_light: Light2D = get_node("TorchLight")
onready var screen_shake = get_node("Camera2D/ScreenShake")
onready var enemy_collision: CollisionShape2D = get_node("EnemyDetector/CollisionShape2D")
onready var inv_timer: Timer = get_node("Invulnerability")
onready var anim_player: AnimationPlayer = $AnimationPlayer

# Torch Stats
const TORCH_COLOR = Color("#FFB075")
const TORCH_UNLIT = Color("#000000")
const MAX_TORCH_STRENGHT = 30.0

var current_color = TORCH_COLOR
var fire_strenght = PlayerData.fire_strenght # Also Player HP
var weight = 1.0 # 1 - Lit ~ 0 - Unlit

# Player Stats
const DAMAGE_MULTIPLIER = 5.0
const PLAYER_MAX_SPEED = 500.0
const RECOIL_IMPACT = 2500.0
const SLOW_FACTOR = 2.0

var current_time = PlayerData.time
var move_speed = 500.0

var touching_enemies = 0

# Invulnerable after hit
const INVULNERABLE_TIME = 1.0
var invulnerable_timer = 0.0
var invulnerable = false

func _ready() -> void:
	current_time = PlayerData.time
	fire_strenght = PlayerData.fire_strenght
	change_torch_strenght()

func _physics_process(delta: float) -> void:
	# Aim and Move
	var direction = get_direction()
	direction = move_and_slide(direction * move_speed)
	look_at(get_global_mouse_position())
	
	if anim_player.current_animation != "Attack":
		if direction == Vector2.ZERO:
			anim_player.play("Idle")
		else:
			anim_player.play("Moving")
	
	# Update Clock
	current_time += delta
	ui_control.update_interface(int (current_time))

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("melee_attack") and anim_player.current_animation != "Attack":
		anim_player.play("Attack")

func get_direction() -> Vector2:
	return Vector2(
		Input.get_action_strength("move_right") - Input.get_action_strength("move_left"),
		Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	).normalized()

func change_speed() -> void:
	if move_speed == PLAYER_MAX_SPEED:
		move_speed = PLAYER_MAX_SPEED / SLOW_FACTOR
	else:
		move_speed = PLAYER_MAX_SPEED

func relight_torch() -> bool:
	if fire_strenght == MAX_TORCH_STRENGHT:
		return false
	else:
		fire_strenght = MAX_TORCH_STRENGHT
		change_torch_strenght()
		return true

func change_torch_strenght() -> void:
	weight = fire_strenght / MAX_TORCH_STRENGHT
	current_color = TORCH_COLOR.linear_interpolate(TORCH_UNLIT, (1 - weight))
	torch_light.color = current_color

func take_damage() -> void:
	if inv_timer.is_stopped():
		fire_strenght -= DAMAGE_MULTIPLIER
		change_torch_strenght()
		if fire_strenght <= 0: # Die :(
			die()
		inv_timer.start()
		# Get player's back facing
		var direction = (get_global_mouse_position() - position).normalized() * (-1)
		direction = move_and_slide(direction * RECOIL_IMPACT)
		# Screen Shake
		# Duration 0.2 s, Frequency (1 / 15) s and amplitude of 32px (16 for each direction)
		screen_shake.start(0.2, 15, 16)

func die() -> void:
	PlayerData.deaths += 1
	#queue_free()

func _on_EnemyDetector_body_entered(_body):
	enemy_collision.set_deferred("disabled", true)
	take_damage()

func _on_Invulnerability_timeout():
	enemy_collision.set_deferred("disabled", false)

func _on_AttackArea_body_entered(body):
	body.take_damage()

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "Attack":
		anim_player.play("Idle")

