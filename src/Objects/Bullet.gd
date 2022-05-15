extends KinematicBody2D

var velocity = Vector2.ZERO
var speed = 300
var span_time = 5

func _physics_process(delta):
	span_time -= delta
	if span_time <= 0:
		queue_free()
	move_and_collide(velocity.normalized() * delta * speed)

func _on_Area2D_body_entered(body):
	body.take_damage()
	queue_free()
