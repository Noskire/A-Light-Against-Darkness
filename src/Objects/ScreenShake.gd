extends Node

var amplitude = 0

onready var camera = get_parent()
onready var tween_node = $ShakeTween

func start(duration: float, frequency: float, amp: int):
	self.amplitude = amp
	
	$Duration.wait_time = duration
	$Frequency.wait_time = 1 / frequency
	$Duration.start()
	$Frequency.start()
	
	_new_shake()

func _new_shake():
	var rand = Vector2()
	rand.x = rand_range(-amplitude, amplitude)
	rand.y = rand_range(-amplitude, amplitude)
	
	tween_node.interpolate_property(camera, "offset", camera.offset, rand, $Frequency.wait_time, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
	tween_node.start()

func _reset():
	tween_node.interpolate_property(camera, "offset", camera.offset, Vector2.ZERO, $Frequency.wait_time, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
	tween_node.start()

func _on_Frequency_timeout():
	_new_shake()

func _on_Duration_timeout():
	_reset()
	$Frequency.stop()
