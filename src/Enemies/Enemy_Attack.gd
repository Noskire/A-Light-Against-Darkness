extends Enemy

onready var anim_player: AnimationPlayer = $AnimationPlayer

func _physics_process(_delta: float) -> void:
	if state == IDLE:
		if is_instance_valid(player):
			look_at(player.position)
			target_pos = player.position - get_global_position()
		if abs(target_pos.x) < 70 and abs(target_pos.y) < 70:
			state = PREPARE
			anim_player.play("Prepare")
		else:
			velocity = target_pos.normalized() * move_velocity
			velocity = move_and_slide(velocity)

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "Prepare":
		state = ATTACK
		anim_player.play("Attack")
	elif anim_name == "Attack":
		state = REST
		anim_player.play("Rest")
	elif anim_name == "Rest":
		state = IDLE
		anim_player.play("Idle")

func _on_AttackArea_body_entered(body):
	body.take_damage()
