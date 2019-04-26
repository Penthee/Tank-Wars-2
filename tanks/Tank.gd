extends KinematicBody2D

signal shoot
signal health_changed
signal missile_ammo_changed
signal dead

export (PackedScene) var Bullet
export (PackedScene) var Missile
export (float) var gun_cooldown
export (int) var health
export (int) var max_health

export (int) var gun_shots = 1
export (float, 0, 1.5) var gun_spread = 0.2
export (int) var max_missile_ammo = 25
export (int) var missile_ammo = -1 setget set_ammo

export (int) var speed
export (int) var max_speed
export (float) var acceleration
export (float) var friction
export (float) var offroad_friction

export (float) var rotation_speed
#export (float) var rot_acceleration
#export (float) var rot_friction

var velocity = Vector2()
var rot_dir = 0
var can_shoot = true
var alive = true
var map

func _ready():
	alive = true
	$Explosion.hide()
	$Explosion.frame = 0
	$Smoke.emitting = false
	$Turret.show()
	$Body.show()
	health = max_health
	emit_signal("health_changed", health * 100/max_health)
	emit_signal("missile_ammo_changed", missile_ammo * 100/max_missile_ammo)
	$GunCooldown.wait_time = gun_cooldown
	$AnimationPlayer.play("init")
	
func control(delta):
	pass
	
func _physics_process(delta):
	if not alive:
		return
		
	control(delta)
	
	if map:
		var tile = map.get_cellv(map.world_to_map(position))
		if tile in GLOBALS.slow_terrain:
			velocity *= offroad_friction
	
	do_rotation(delta)
	do_movement(delta)

func do_rotation(delta):
	rotation += rotation_speed * rot_dir * delta

func do_movement(delta):
	velocity = lerp(velocity, Vector2(0, 0), friction * delta)
	move_and_slide(velocity)
	
func shoot(_num, _spread, _target=null):
	_do_the_shoot(Bullet, _num, _spread, _target)

func shoot_missile(_num, _spread, _target=null):
	if (missile_ammo != 0):
		self.missile_ammo -= 1
		_do_the_shoot(Missile, _num, _spread, _target)
	
func _do_the_shoot(_bullet, _num, _spread, _target=null):
	if can_shoot and alive:
		can_shoot = false
		$GunCooldown.start()
			
		var dir = Vector2(1, 0).rotated($Turret.global_rotation)
		
		if _num > 1:
			for i in range(_num):
				var a = -_spread + i * (2*_spread)/(_num-1)
				emit_signal("shoot", _bullet, $Turret/Barrel/ShootSpawn.global_position, dir.rotated(a), _target)
		else:
			emit_signal("shoot", _bullet, $Turret/Barrel/ShootSpawn.global_position, dir, _target)
			
		$AnimationPlayer.play("muzzle_flash")
		$AnimationPlayer.play("fire")

func set_ammo(_amount):
	missile_ammo = clamp(missile_ammo, _amount, max_missile_ammo)
	emit_signal("missile_ammo_changed", missile_ammo * 100/max_missile_ammo)

func take_damage(_damage):
	if health <= 0:
		return
		
	if health < max_health * 0.5:
		$Smoke.emitting = true
	
	health = clamp(health - _damage, 0, health)
	emit_signal("health_changed", health * 100/max_health)
	
	if health <= 0:
		explode()

func heal(_amount):
	if health >= max_health:
		return
	
	if health > max_health * 0.25:
		$Smoke.emitting = false
	
	health = clamp(health + _amount, 0, max_health)
	emit_signal("health_changed", health * 100/max_health)

func explode():
	alive = false
	#$CollisionPolygon2D.disabled = true
	$Turret.hide()
	$Body.hide()
	$Smoke.emitting = false
	$Explosion.show()
	$Explosion.play()

func _on_GunCooldown_timeout():
	can_shoot = true

func _on_Explosion_animation_finished():
	#yield(get_tree().create_timer(5),"timeout")
	emit_signal("dead")
	queue_free()
