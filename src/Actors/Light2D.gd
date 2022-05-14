extends Light2D

onready var player: Node2D = get_parent()

var current_color = GameInfo.TORCH_COLOR
var current_time = 0.0
var weight = 1.0

func _process(delta):
	current_time += delta
	weight = current_time / GameInfo.total_time
	current_color = GameInfo.TORCH_COLOR.linear_interpolate(GameInfo.TORCH_UNLIT, weight)
	self.color = current_color
	PlayerData.time = int (current_time)
	if current_time >= GameInfo.total_time:
		player.die()
