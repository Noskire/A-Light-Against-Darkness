extends Area2D

const MUD = 1

func _on_body_entered(body):
	body.change_speed(MUD)

func _on_body_exited(body):
	body.change_speed(MUD)
