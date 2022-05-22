extends Enemy

onready var scene_tree = get_tree()
onready var tile_map = get_parent().get_parent().get_node("TileMap")
onready var popup = get_parent().get_parent().get_node("UserInterface/Popup")
onready var chat_window = get_parent().get_parent().get_node("UserInterface/Popup/Bg/MarginC/VBoxC")
onready var anim_player: AnimationPlayer = $AnimationPlayer
onready var sfx_boss = get_node("SFXBoss")
onready var hurt = preload("res://assets/sounds/p_hurt.wav")
onready var bullet_path = preload("res://src/Objects/Bullet.tscn")

# Attacks
const FAST = 0
const CHARGE = 1
const MELEE = 2
const SHOOT = 3

const FAST_FACTOR = 1.5

var LIFE = 5
var rand = 0

var chat = true
var nice_response = false
var bad_response = false

func _physics_process(_delta: float) -> void:
	if chat and not popup.is_visible():
		enemy_pos = get_global_position()
		if is_instance_valid(player):
			look_at(player.position)
			target_pos = player.position - enemy_pos
		direction = target_pos.normalized()
		velocity = (direction * move_velocity)
		velocity = move_and_slide(velocity)
		if abs(target_pos.x) < 300 and abs(target_pos.y) < 300:
			scene_tree.paused = true
			popup.set_visible(true)
	elif nice_response:
		enemy_pos = get_global_position()
		if is_instance_valid(player):
			look_at(player.position)
			target_pos = player.position - enemy_pos
		direction = target_pos.normalized()
		velocity = (direction * move_velocity)
		if abs(target_pos.x) > 100 or abs(target_pos.y) > 100:
			velocity = move_and_slide(velocity)
	elif LIFE > 0:
		if state in [REST, PREPARE]:
			if is_instance_valid(player):
				look_at(player.position)
		if state == IDLE:
			enemy_pos = get_global_position()
			if is_instance_valid(player):
				target_pos = player.position - enemy_pos
			if rand == SHOOT:
				state = PREPARE
				anim_player.play("Prepare")
			else:
				# Move towards player
				direction = target_pos.normalized()
				if is_instance_valid(player):
					look_at(player.position)
				velocity = (direction * move_velocity)
				if rand == FAST:
					velocity = velocity * FAST_FACTOR
					velocity = move_and_slide(velocity)
				else:
					velocity = move_and_slide(velocity)
				if rand == CHARGE and abs(target_pos.x) < 300 and abs(target_pos.y) < 300:
					state = PREPARE
					anim_player.play("Prepare")
				elif rand == MELEE and abs(target_pos.x) < 100 and abs(target_pos.y) < 100:
					state = PREPARE
					anim_player.play("Prepare")
				#else, if rand = FAST, moves until timer ends
		elif state == ATTACK and rand == CHARGE:
			velocity = target_pos.normalized() * move_velocity * 3
			velocity = move_and_slide(velocity)
		elif state == FLEEING:
			velocity = move_and_slide(velocity)

func take_damage() -> void:
	LIFE -= 1
	sfx_boss.stream = hurt
	sfx_boss.play()
	if LIFE == 0:
		$MoonLight.set_visible(false)
		anim_player.play("Fleeing")
		GlobalSettings.update_achievement("Merciless Wretch!")

func shoot() -> void:
	var vel_b
	if is_instance_valid(player):
		vel_b = (player.position - enemy_pos).normalized()

	var bullet = bullet_path.instance()
	get_parent().add_child(bullet)
	bullet.position = $BulletSpawnPoint.global_position
	bullet.velocity = vel_b.rotated(deg2rad(30))

	var bullet2 = bullet_path.instance()
	get_parent().add_child(bullet2)
	bullet2.position = $BulletSpawnPoint.global_position
	bullet2.velocity = vel_b

	var bullet3 = bullet_path.instance()
	get_parent().add_child(bullet3)
	bullet3.position = $BulletSpawnPoint.global_position
	bullet3.velocity = vel_b.rotated(deg2rad(-30))

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "Idle":
		if rand == FAST:
			state = REST
			anim_player.play("Rest")
		state = PREPARE
		anim_player.play("Prepare")
	elif anim_name == "Prepare":
		state = ATTACK
		if rand == CHARGE:
			anim_player.play("Charge")
		elif rand == MELEE:
			anim_player.play("Melee")
		elif rand == SHOOT:
			shoot()
			anim_player.play("Shoot")
	elif anim_name == "Charge" or anim_name == "Melee" or anim_name == "Shoot":
		state = REST
		anim_player.play("Rest")
	elif anim_name == "Rest":
		state = IDLE
		$MovingTimer.start()
		# Choose next attack method
		rand = int(rand_range(0, 4))
		if rand == 4:
			rand = 3
		anim_player.play("Idle")
	elif anim_name == "Fleeing":
		#queue_free()
		pass

func _on_MovingTimer_timeout():
	if anim_player.get_current_animation() == "Idle":
		state = REST
		anim_player.play("Rest")

func _on_NoBtn_button_up():
	if chat:
		chat_window.get_node("Speech1").set_visible(false)
		chat_window.get_node("Speech2").set_visible(true)
		chat_window.get_node("HBoxB/YesBtn").set_disabled(true)
		chat = false
		bad_response = true
	else:
		if LIFE > 0:
			scene_tree.paused = false
			popup.set_visible(false)
		else:
			scene_tree.paused = false
			popup.set_visible(false)
			
			$DamageTimer.start()

func _on_YesBtn_button_up():
	if chat:
		chat_window.get_node("Speech1").set_visible(false)
		chat_window.get_node("Speech3").set_visible(true)
		chat_window.get_node("HBoxB/NoBtn").set_disabled(true)
		chat = false
		LIFE = 0
		$CollisionShape2D.set_disabled(true)
		$AttackArea/CollisionShape2D.set_disabled(true)
		anim_player.play("Idle")
		nice_response = true
		tile_map.set_cell(27, 9, 0, false, false, false, Vector2(0, 0))
		tile_map.set_cell(31, 9, 0, false, false, false, Vector2(0, 0))
	else:
		scene_tree.paused = false
		popup.set_visible(false)

func _on_AttackArea_body_entered(body):
	body.take_damage()

func _on_FinalArea_body_entered(_body):
	if bad_response and LIFE <= 0:
		scene_tree.paused = true
		popup.set_visible(true)
		chat_window.get_node("HBoxL").set_visible(false)
		chat_window.get_node("Speech2").set_visible(false)
		chat_window.get_node("Speech4").set_visible(true)
		get_parent().get_parent().get_node("FinalArea").set_position(Vector2(0,0))

func _on_DamageTimer_timeout():
	player.take_damage()
	$DamageTimer.start()
