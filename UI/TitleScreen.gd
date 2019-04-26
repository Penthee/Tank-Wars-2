extends Control

func _input(event):
	if event.is_action_pressed("ui_select"):
		$AnimationPlayer.play("start")

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "start":
		GLOBALS.next_level()
