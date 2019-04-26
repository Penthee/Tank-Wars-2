extends Area2D

enum Items {health, ammo}

var icon_textures = [preload("res://assets/UI/shield_silver_green.png"),
					 preload("res://assets/UI/missile.png")]

export (Items) var type setget _update
export (Vector2) var amount = Vector2(10, 25)

func _ready():
	_update(type)

func _update(_type):
	type = _type
	$Icon.global_rotation = 0
	$Icon.texture = icon_textures[type]

func _on_Pickup_body_entered(body):
	match(type):
		Items.health:
			if body.has_method("heal"):
				body.heal(get_amount())
		Items.ammo:
			if body.has_method("set_ammo"):
				body.set_ammo(get_amount())
	
	queue_free()

func get_amount():
	return rand_range(amount.x, amount.y)
