extends "res://tanks/Tank.gd"

func control(delta):
	$Turret.look_at(get_global_mouse_position())
	
	rot_dir = 0
	
	if Input.is_action_pressed("turn_left"):
		rot_dir -= rotation_speed
	if Input.is_action_pressed("turn_right"):
		rot_dir += rotation_speed
	
	if Input.is_action_pressed("forward"):
		velocity += Vector2(speed, 0).rotated(rotation)
	if Input.is_action_pressed("back"):
		velocity += Vector2(-speed * 0.5, 0).rotated(rotation)
	
	if Input.is_action_just_pressed("shoot"):
		shoot(gun_shots, gun_spread, null)
	if Input.is_action_just_pressed("shoot_missile") and missile_ammo > 0:
		missile_ammo -= 1
		shoot_missile(gun_shots, gun_spread, get_target())
		
# this sucks - redo it, it doesn't detect enemy tanks, only turrets
func get_target():
	var enemies = find_node_by_name(get_tree().get_root(), "Enemies").get_children()
	var targets = enemies[0].get_children() + enemies[1].get_children() 
	var nearest = targets[0]
	
	var pos = get_global_mouse_position()
	
	for target in targets:
		if target is KinematicBody2D and target.global_position.distance_to(pos) < nearest.global_position.distance_to(pos):
			nearest = target
	print("Target: ", nearest.name)
	return nearest
	
func find_node_by_name(root, name):

    if(root.get_name() == name): return root

    for child in root.get_children():
        if(child.get_name() == name):
            return child

        var found = find_node_by_name(child, name)

        if(found): return found

    return null