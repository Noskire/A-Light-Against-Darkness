extends Area2D

func _on_body_entered(body):
	body.relight_torch()
	queue_free()