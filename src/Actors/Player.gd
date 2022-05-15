extends KinematicBody2D

onready var screen_shake = get_node("Camera2D/ScreenShake")
onready var torch: Light2D = get_node("Torch")
onready var enemy_detector: Area2D = $EnemyDetector
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
const SLOW_FACTOR_MUD = 2.0
const SLOW_FACTOR_WATER = 1.5

var current_time = PlayerData.time
var move_speed = 500.0
var slowed = false

var touching_enemies = 0
var attacking = false

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
	
	# Update Clock
	current_time += delta
	#PlayerData.time = int (current_time)
	get_parent().get_node("UserInterface/UserInterface").update_interface(int (current_time))
	
	# Update Invulnerable Timer
	if invulnerable:
		invulnerable_timer -= delta
		if invulnerable_timer <= 0:
			invulnerable = false
	
	if not invulnerable and touching_enemies > 0:
		take_damage()
	
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

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("melee_attack") and not attacking:
		attacking = true
		anim_player.play("Attack")

func change_speed(value: int) -> void:
	slowed = not slowed
	if slowed:
		if value == 1: # Mud
			move_speed = PLAYER_MAX_SPEED / SLOW_FACTOR_MUD
		if value == 2: # Water
			move_speed = PLAYER_MAX_SPEED / SLOW_FACTOR_WATER
	else:
		move_speed = PLAYER_MAX_SPEED

func relight_torch() -> void:
	fire_strenght = MAX_TORCH_STRENGHT
	change_torch_strenght()

func take_damage() -> void:
	if not invulnerable:
		fire_strenght -= DAMAGE_MULTIPLIER
		change_torch_strenght()
		invulnerable = true
		invulnerable_timer = INVULNERABLE_TIME
		
		# Get player's back facing
		var direction = (get_global_mouse_position() - position).normalized() * (-1)
		direction = move_and_slide(direction * RECOIL_IMPACT)
		# Screen Shake
		# Duration 0.2 s, Frequency (1 / 15) s and amplitude of 32px (16 for each direction)
		screen_shake.start(0.2, 15, 16)

func change_torch_strenght() -> void:
	weight = fire_strenght / MAX_TORCH_STRENGHT
	current_color = TORCH_COLOR.linear_interpolate(TORCH_UNLIT, (1 - weight))
	torch.color = current_color

func die() -> void:
	PlayerData.deaths += 1
	queue_free()

func _on_EnemyDetector_body_entered(_body):
	touch_enemy(1)

func _on_EnemyDetector_body_exited(_body):
	touch_enemy(-1)

func touch_enemy(value: int) -> void:
	touching_enemies += value

func _on_AttackArea_body_entered(body):
	body.take_damage()

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "Attack":
		attacking = false
