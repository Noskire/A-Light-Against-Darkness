tool
extends Area2D

onready var anim_player: AnimationPlayer = $AnimationPlayer

export var next_scene: PackedScene

var player: Node2D

func _on_body_entered(body):
	player = body
	go_up()

func _get_configuration_warning() -> String:
	return "The next scene property can't be empty" if not next_scene else ""

func go_up() -> void:
	anim_player.play("fade_in")
	yield(anim_player, "animation_finished")
	
	# Save time and pass on
	PlayerData.time = int (player.current_time)
	PlayerData.fire_strenght = player.fire_strenght
	
	var err
	err = get_tree().change_scene_to(next_scene)
	if err != OK:
		print("Error" + "ChangeScenePortal")
