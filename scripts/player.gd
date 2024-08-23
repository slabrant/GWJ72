extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -300.0
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
@onready var sprite = $DefaultSprite
@onready var pointer_sprite = $PointerSprite
var spit = preload("res://scenes/spit.tscn")


func _on_ready():
	pointer_sprite.offset.x = 32


func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		
	var direction = Input.get_axis("move_left", "move_right")
	if Input.is_action_just_pressed("shoot"):
		var new_spit = spit.instantiate()
		new_spit.position.x = $".".position.x
		new_spit.position.y = $".".position.y
		new_spit.velocity = get_local_mouse_position().normalized() * new_spit.SPEED
		# TODO: figure out spitting sprite.
		sprite.play("spit")
		$".".add_sibling(new_spit)
	
	if direction:
		sprite.flip_h = direction == -1
		velocity.x = direction * SPEED
		pointer_sprite.offset.x = 32
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	if !is_on_floor():
		sprite.play("jump")
	elif direction:
		sprite.play("walk")
	else:
		sprite.play("idle")
	
	pointer_sprite.rotation = get_local_mouse_position().normalized().angle()
	
	move_and_slide()


func set_sprite(type):
	
	var flip_h = sprite.flip_h
	if type == 'dark':
		sprite.hide()
		sprite = $DarkSprite
		sprite.show()
	elif type == 'light':
		sprite.hide()
		sprite = $LightSprite
		sprite.show()
	else:
		sprite.hide()
		sprite = $DefaultSprite
		sprite.show()
	
	sprite.flip_h = flip_h
