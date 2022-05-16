extends KinematicBody2D
class_name Enemy

onready var player: Node2D = get_parent().get_node("Player")

export var move_velocity = Vector2(300.0, 300.0)
export var state = 0

export var enemy_pos = Vector2()
export var target_pos = Vector2()
export var direction = Vector2()
export var velocity = Vector2()

# States
const IDLE = 0
const PREPARE = 1
const ATTACK = 2
const REST = 3

func _ready() -> void:
	# "Freeze" the enemy until the VisibilityEnabler2D be visible by the view
	set_physics_process(false)

func take_damage() -> void:
	queue_free()
