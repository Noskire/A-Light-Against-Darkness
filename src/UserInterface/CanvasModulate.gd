extends CanvasModulate

export var initial_color = Color("#303A3D")
export var final_color = Color("#000000")
export var current_color = Color("#303A3D")
export var transition_time = 1.0
export var timer = 0.0
export var weight = 0

func _physics_process(delta: float) -> void:
	if timer > 0:
		timer -= delta
		weight = timer / transition_time
		color = initial_color.linear_interpolate(final_color, (1 - weight))

func get_darker():
	timer = transition_time
