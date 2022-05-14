extends KinematicBody2D

var move_speed = 500.0
var _velocity: = Vector2.ZERO

func _physics_process(delta: float) -> void:
	var direction: = get_direction()
	direction = move_and_slide(direction * move_speed)

	look_at(get_global_mouse_position())

func get_direction() -> Vector2:
	var out: = Vector2(
		Input.get_action_strength("move_right") - Input.get_action_strength("move_left"),
		Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	)
	out = out.normalized()
	return out

func die() -> void:
	PlayerData.deaths += 1
	queue_free()
