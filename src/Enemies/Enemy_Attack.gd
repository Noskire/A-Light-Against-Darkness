extends KinematicBody2D

onready var player: Node2D = get_parent().get_node("Player")
onready var anim_player: AnimationPlayer = $AnimationPlayer

export var move_velocity = Vector2(300.0, 300.0)

# States
const IDLE = 0
const PREPARE = 1
const ATTACK = 2
const REST = 3
var state = IDLE

# Use a AnimationPlayer instead
const REST_TIME = 0.5
var rest_timer = REST_TIME

# Use a AnimationPlayer instead
const PREPARE_TIME = 0.3
var prepare_timer = PREPARE_TIME

var enemy_pos = Vector2()
var target_distante = Vector2()
var direction = Vector2()
var velocity = Vector2()

func _ready() -> void:
	# "Freeze" the enemy until the VisibilityEnabler2D be visible by the view
	set_physics_process(false)

func _physics_process(delta: float) -> void:
	if state in [IDLE, REST]:
		enemy_pos = get_global_position()
		look_at(player.position)
	if state == IDLE:
		direction = (player.position - enemy_pos).normalized()
		velocity = direction * move_velocity
		velocity = move_and_slide(velocity)
		
		target_distante = player.position - enemy_pos
		if abs(target_distante.x) < 70 and abs(target_distante.y) < 70:
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
	elif new_state == ATTACK:
		anim_player.play("Attack")

func take_damage() -> void:
	queue_free()

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "Attack":
		go_to_state(REST)

func _on_AttackArea_body_entered(body):
	body.take_damage()
