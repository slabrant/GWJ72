extends CharacterBody2D

@export var SPEED = 400.0
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
@onready var sprite = $AnimatedSprite2D
@onready var collision_shape = $CollisionShape2D
@onready var timer = $Timer

func _physics_process(delta):
	if move_and_slide() and timer.time_left <= 0:
		splash()
		$".".rotation = get_last_slide_collision().get_normal().angle() + (PI/2)
	elif timer.time_left <= 0:
		velocity.y += gravity * delta
		$".".rotation = velocity.angle() - (PI/2)


func _on_animated_sprite_2d_ready():
	$".".rotation = get_local_mouse_position().angle() - (PI/2)


func splash():
	velocity = Vector2(0,0)
	sprite.play("splash")
	timer.start(0.2)


func _on_timer_timeout():
	queue_free()
