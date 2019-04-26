extends CanvasLayer

var bar_red = preload("res://assets/UI/barHorizontal_red_mid 200.png")
var bar_green = preload("res://assets/UI/barHorizontal_green_mid 200.png")
var bar_yellow = preload("res://assets/UI/barHorizontal_yellow_mid 200.png")

var health_bar_texture
var missile_bar_texture

func update_healthbar(value):
	health_bar_texture = bar_green
	if value < 60:
		health_bar_texture = bar_yellow
	if value < 25:
		health_bar_texture = bar_red
	
	$Margin/VBox/HealthHBox/HealthBar.texture_progress = health_bar_texture
	
	$Margin/VBox/HealthHBox/HealthBar/Tween.interpolate_property($Margin/VBox/HealthHBox/HealthBar,
		'value', $Margin/VBox/HealthHBox/HealthBar.value, value, 
		0.2, Tween.TRANS_CIRC, Tween.EASE_IN_OUT)
		
	$Margin/VBox/HealthHBox/HealthBar/Tween.start()
	$AnimationPlayer.play("healthbar_flash")


func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "healthbar_flash":
		$Margin/VBox/HealthHBox/HealthBar.texture_progress = health_bar_texture

func update_missile_ammo(value):
	missile_bar_texture = bar_green
	if value < 60:
		missile_bar_texture = bar_yellow
	if value < 25:
		missile_bar_texture = bar_red
	
	$Margin/VBox/AmmoHBox/AmmoBar.texture_progress = missile_bar_texture
	
	$Margin/VBox/AmmoHBox/AmmoBar/Tween.interpolate_property($Margin/VBox/AmmoHBox/AmmoBar,
		'value', $Margin/VBox/AmmoHBox/AmmoBar.value, value, 
		0.2, Tween.TRANS_CIRC, Tween.EASE_IN_OUT)
		
	$Margin/VBox/AmmoHBox/AmmoBar/Tween.start()