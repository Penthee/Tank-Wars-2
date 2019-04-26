extends "res://tanks/Tank.gd"

onready var parent = get_parent()

export (float) var turret_speed = 0.3
export (int) var detect_radius = 500
export (int) var missile_chance = 20

var target = null
var target_in_stop_radius = false

func _ready():
	var circle = CircleShape2D.new()
	$DetectRadius/CollisionShape2D.shape = circle
	$DetectRadius/CollisionShape2D.shape.radius = detect_radius

func control(delta):
	if target_in_stop_radius:
		speed = lerp(speed, 0, friction)
	else:
		speed = lerp(speed, max_speed, friction)
		
	if parent is PathFollow2D:
		parent.set_offset(parent.get_offset() + (speed * delta))
		position = Vector2()
	else:
		# random roaming movement - change velocity
		pass

func _process(delta):
	if target:
		var target_dir = (target.global_position - global_position).normalized()
		var current_dir = Vector2(1, 0).rotated($Turret.global_rotation)
		$Turret.global_rotation = current_dir.linear_interpolate(target_dir, turret_speed * delta).angle()
		
		if target_dir.dot(current_dir) > 0.9:
			if randi()%101+1 > missile_chance:
				shoot(gun_shots, gun_spread, target)
			else:
				shoot_missile(gun_shots, gun_spread, target)

func _on_DetectRadius_body_entered(body):
	if body.name == "Player":
		target = body

func _on_DetectRadius_body_exited(body):
	if body == target:
		target = null

func _on_StopRadius_body_entered(body):
	if target and body.name == "Player":
		print("Enemy Tank Stop Radius Hit: ", body.name)
		target_in_stop_radius = true

func _on_StopRadius_body_exited(body):
	target_in_stop_radius = false
