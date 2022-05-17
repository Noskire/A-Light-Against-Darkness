extends Enemy

onready var anim_player: AnimationPlayer = $AnimationPlayer
onready var bullet_path = preload("res://src/Objects/Bullet.tscn")

# Vars to rand movement
export var amplitude = 45
export var rand = 0

func _physics_process(_delta: float) -> void:
	if state in [REST, PREPARE]:
		if is_instance_valid(player):
			look_at(player.position)
	if state == IDLE:
		enemy_pos = get_global_position()
		if is_instance_valid(player):
			target_pos = player.position - enemy_pos
		if abs(target_pos.x) > 500 or abs(target_pos.y) > 500:
			# Move towards player
			direction = target_pos.normalized()
			if is_instance_valid(player):
				look_at(player.position)
			velocity = (direction * move_velocity)
			velocity = move_and_slide(velocity)
		elif abs(target_pos.x) > 300 or abs(target_pos.y) > 300:
			state = PREPARE
			anim_player.play("Prepare")
		else:
			# Move away from player
			direction = target_pos.normalized() * (-1)
			look_at(enemy_pos + direction)
			velocity = (direction * move_velocity).rotated(deg2rad(rand))
			velocity = move_and_slide(velocity)
	elif state == FLEEING:
		velocity = move_and_slide(velocity)

func take_damage() -> void:
	state = FLEEING
	anim_player.play("Fleeing")
	# Move away from player
	direction = target_pos.normalized() * (-1)
	look_at(enemy_pos + direction)
	velocity = (direction * move_velocity)

func shoot() -> void:
	var bullet = bullet_path.instance()
	get_parent().add_child(bullet)
	bullet.position = $BulletSpawnPoint.global_position
	if is_instance_valid(player):
		bullet.velocity = (player.position - enemy_pos).normalized()

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "Idle":
		state = PREPARE
		anim_player.play("Prepare")
	elif anim_name == "Prepare":
		state = ATTACK
		shoot()
		anim_player.play("Attack")
	elif anim_name == "Attack":
		state = REST
		anim_player.play("Rest")
	elif anim_name == "Rest":
		state = IDLE
		rand = rand_range(-amplitude, amplitude)
		anim_player.play("Idle")
	elif anim_name == "Fleeing":
		queue_free()
