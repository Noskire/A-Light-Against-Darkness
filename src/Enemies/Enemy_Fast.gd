extends KinematicBody2D

onready var player: Node2D = get_parent().get_node("Player")

export var impulse = Vector2(300.0, 300.0)

var enemy_pos = Vector2()
var target_pos = Vector2()
var direction = Vector2()
var velocity = Vector2()

func _ready() -> void:
	# "Freeze" the enemy until the VisibilityEnabler2D be visible by the view
	set_physics_process(false)

func _physics_process(_delta: float) -> void:
	enemy_pos = get_global_position()
	target_pos = player.position
	direction = (target_pos - enemy_pos).normalized()
	
	look_at(target_pos)
	velocity = direction * impulse
	velocity = move_and_slide(velocity)

func take_damage() -> void:
	queue_free()
