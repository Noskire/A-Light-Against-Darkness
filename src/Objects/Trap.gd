extends Area2D

onready var anim_player: AnimationPlayer = $AnimationPlayer

var state = "Rest"

func _on_body_entered(body):
	if state == "Rest": # Playing Idle
		anim_player.play("Prepare")
	else:
		body.take_damage()

func _on_animation_finished(anim_name):
	state = anim_name
	if anim_name == "Idle":
		anim_player.play("Prepare")
	elif anim_name == "Prepare":
		anim_player.play("Attack")
	elif anim_name == "Attack":
		anim_player.play("Rest")
	elif anim_name == "Rest":
		anim_player.play("Idle")
