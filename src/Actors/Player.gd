extends KinematicBody2D

onready var ui_control: Control = get_parent().get_node("UserInterface/UserInterface")
onready var fire_sprite: Sprite = get_node("Fire")
onready var torch_light: Light2D = get_node("Fire/Light")
onready var screen_shake = get_node("Camera2D/ScreenShake")
onready var enemy_collision: CollisionShape2D = get_node("EnemyDetector/CollisionShape2D")
onready var inv_timer: Timer = get_node("Invulnerability")
onready var anim_player: AnimationPlayer = $AnimationPlayer
onready var sfx_player: AudioStreamPlayer = $SFX_Player

onready var sprite_to_lvl01 = preload("res://assets/images/Willow_Sprite_Torch.png")

onready var step1 = preload("res://assets/sounds/p_footstep1.wav")
onready var step2 = preload("res://assets/sounds/p_footstep2.wav")
onready var hit = preload("res://assets/sounds/p_hit.wav")
onready var hurt = preload("res://assets/sounds/p_hurt.wav")

export var current_scene_id: int

# Torch Stats
const TORCH_COLOR = Color("#FFB075")
const TORCH_UNLIT = Color("#000000")
const MAX_TORCH_STRENGHT = 30.0

var current_color = TORCH_COLOR
var fire_strenght # Also Player HP
var weight = 1.0 # 1 - Lit ~ 0 - Unlit

# Player Stats
const DAMAGE_MULTIPLIER = 5.0
const PLAYER_MAX_SPEED = 500.0
const RECOIL_IMPACT = 2500.0
const SLOW_FACTOR = 2.0

var current_time
var move_speed = 500.0
var touching_enemies = 0
var p_direction

# Invulnerable after hit
const INVULNERABLE_TIME = 1.0
var invulnerable_timer = 0.0
var invulnerable = false

var pass_sfx = 0
var lvl01_event = false

func _ready() -> void:
	fire_strenght = GlobalSettings.get_level_light(current_scene_id - 1)
	current_time = 0
	change_torch_strenght()

func _physics_process(delta: float) -> void:
	# Aim and Move
	if not lvl01_event:
		p_direction = get_direction()
		p_direction = move_and_slide(p_direction * move_speed)
		look_at(get_global_mouse_position())
		
		if anim_player.current_animation != "Attack":
			if p_direction == Vector2.ZERO:
				anim_player.play("Idle")
			else:
				anim_player.play("Moving")
		
		# Update Clock
		current_time += delta
		ui_control.update_interface(int (current_time))
	else:
		look_at(Vector2(1950, 750))
		p_direction = (Vector2(1950, 750) - position)
		if abs(p_direction.x) < 5 and abs(p_direction.y) < 5:
			$Sprite.set_texture(sprite_to_lvl01)
			get_parent().get_node("TorchToCatch/Area2D/CollisionShape2D").set_disabled(true)
			get_parent().get_node("TorchToCatch").set_visible(false)
			lvl01_event = false
		else:
			p_direction = p_direction.normalized()
			p_direction = move_and_slide(p_direction * move_speed)

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("Attack") and anim_player.current_animation != "Attack":
		sfx_player.stream = hit
		anim_player.play("Attack")

func get_direction() -> Vector2:
	return Vector2(
		Input.get_action_strength("Right") - Input.get_action_strength("Left"),
		Input.get_action_strength("Down") - Input.get_action_strength("Up")
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
	fire_sprite.modulate.a = weight

	var diff = -50 - (-50 - Save.game_data.sfx_vol) * weight
	$Fire/FireSound.set_volume_db(diff)

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
		sfx_player.stream = hurt
		sfx_player.play()

func die() -> void:
	GlobalSettings.update_level(current_scene_id, 0.0, 0.0, 1)
	ui_control.player_died()
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

func _on_FireSound_finished():
	$Fire/FireSound.play()

func _on_SFX_Player_finished():
	if move_speed == PLAYER_MAX_SPEED:
		sfx_player.stream = step2
	else:
		sfx_player.stream = step1

func _on_Area2D_body_entered(_body):
	lvl01_event = true
