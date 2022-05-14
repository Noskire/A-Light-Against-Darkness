extends Area2D

onready var anim_player: AnimationPlayer = $AnimationPlayer
onready var act_timer: Timer = $ActivateTimer

var touching = false
var delay = false
var actor: Node2D

func _on_body_entered(body):
	actor = body
	touching = true
	if not delay:
		delay = true
		act_timer.start()

func _on_body_exited(_body):
	touching = false

func _on_ActivateTimer_timeout():
	anim_player.play("Activate")

func _on_animation_finished(anim_name):
	if anim_name == "Activate":
		if touching:
			# Player/Enemy takes damage
			actor.take_damage()
			pass
		anim_player.play("Desactivate")
	if anim_name == "Desactivate":
		if touching:
			act_timer.start()
		else:
			delay = false
