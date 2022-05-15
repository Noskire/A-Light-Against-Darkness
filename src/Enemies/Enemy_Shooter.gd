extends KinematicBody2D

onready var player: Node2D = get_parent().get_node("Player")
onready var anim_player: AnimationPlayer = $AnimationPlayer
onready var bullet_path = preload("res://src/Objects/Bullet.tscn")

export var move_velocity = Vector2(300.0, 300.0)

# States
const MOVE = 0
const PREPARE = 1
const ATTACK = 2
const REST = 3
var state = MOVE

# Use a AnimationPlayer instead
const MOVE_TIME = 1.0
var move_timer = MOVE_TIME

# Use a AnimationPlayer instead
const REST_TIME = 0.5
var rest_timer = REST_TIME

# Use a AnimationPlayer instead
const PREPARE_TIME = 0.2
var prepare_timer = PREPARE_TIME

var enemy_pos = Vector2()
var target_distante = Vector2()
var direction = Vector2()
var velocity = Vector2()

func _ready() -> void:
	# "Freeze" the enemy until the VisibilityEnabler2D be visible by the view
	set_physics_process(false)

func _physics_process(delta: float) -> void:
	if state in [MOVE, REST]:
		enemy_pos = get_global_position()
		look_at(player.position)
	if state == MOVE:
		move_timer -= delta
		
		direction = (player.position - enemy_pos).normalized()
		#Invert direction to get away from player
		direction = direction * (-1)
		velocity = direction * move_velocity
		velocity = move_and_slide(velocity)
		
		target_distante = player.position - enemy_pos
		if move_timer <= 0 or abs(target_distante.x) > 300 or abs(target_distante.y) > 300:
			go_to_state(PREPARE)
	elif state == PREPARE:
		prepare_timer -= delta
		if prepare_timer <= 0:
			go_to_state(ATTACK)
	elif state == REST:
		rest_timer -= delta
		if rest_timer <= 0:
			go_to_state(MOVE)

func go_to_state(new_state):
	state = new_state
	if new_state == MOVE:
		move_timer = MOVE_TIME
	elif new_state == REST:
		rest_timer = REST_TIME
	elif new_state == PREPARE:
		prepare_timer = PREPARE_TIME
	elif new_state == ATTACK:
		shoot()
		anim_player.play("Shoot")

func shoot() -> void:
	var bullet = bullet_path.instance()
	
	get_parent().add_child(bullet)
	bullet.position = $BulletSpawnPoint.global_position
	bullet.velocity = (player.position - enemy_pos).normalized()

func take_damage() -> void:
	print("shooter died")
	queue_free()

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "Shoot":
		go_to_state(REST)
