extends Enemy

onready var anim_player: AnimationPlayer = $AnimationPlayer

func _physics_process(_delta: float) -> void:
	if state == FLEEING:
		velocity = move_and_slide(velocity)
	else:
		if is_instance_valid(player):
			look_at(player.position)
			direction = (player.position - get_global_position()).normalized()
		velocity = direction * move_velocity
		velocity = move_and_slide(velocity)

func take_damage() -> void:
	state = FLEEING
	anim_player.play("Fleeing")
	# Move away from player
	enemy_pos = get_global_position()
	if is_instance_valid(player):
		target_pos = player.position - enemy_pos
	direction = target_pos.normalized() * (-1)
	look_at(enemy_pos + direction)
	velocity = (direction * move_velocity)

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "Fleeing":
		queue_free()
