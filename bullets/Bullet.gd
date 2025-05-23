extends Node2D

export (int) var speed
export (int) var damage
export (float) var lifetime
export (float) var steer_force

var velocity = Vector2()
var acceleration = Vector2()
var target = null

func _ready():
	pass
	
func start(_position, _direction, _target=null):
	position = _position
	rotation = _direction.angle()
	velocity = _direction * speed
	
	$Lifetime.wait_time = lifetime
	$Lifetime.start()
	
	target = _target

func seek():
	var desired = (target.position - position).normalized() * speed
	var steer = (desired - velocity).normalized() * steer_force
	return steer

func _process(delta):
	position += velocity * delta
	if target and is_instance_valid(target):
		acceleration += seek()
		velocity += acceleration * delta
		velocity = velocity.clamped(speed)
		rotation = velocity.angle()
	elif name.match("Missile"):
		explode()

func explode():
	velocity = Vector2()
	$Sprite.hide()
	$Explosion.show()
	$Explosion.play("smoke")

func _on_Lifetime_timeout():
	explode()

func _on_Bullet_body_entered(body):
	if body.has_method("take_damage"):
		body.take_damage(damage)
	explode()

func _on_Explosion_animation_finished():
	queue_free()
