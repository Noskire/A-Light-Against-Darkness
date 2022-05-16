extends Area2D

func _on_body_entered(body):
	body.change_speed()

func _on_body_exited(body):
	body.change_speed()
