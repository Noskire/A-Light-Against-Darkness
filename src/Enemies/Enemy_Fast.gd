extends Enemy

func _physics_process(_delta: float) -> void:
	if is_instance_valid(player):
		look_at(player.position)
		direction = (player.position - get_global_position()).normalized()
	velocity = direction * move_velocity
	velocity = move_and_slide(velocity)
