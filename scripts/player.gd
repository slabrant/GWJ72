extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -300.0
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
@onready var body_sprite = $DefaultSprite
@onready var mouth_sprite = $MouthSprite
@onready var pointer_sprite = $PointerSprite
@onready var health_sprite = $HealthSprite
@onready var quack1 = $Quack1
@onready var is_spitting = false
@onready var spit_power_time = 0.0
@onready var original_position = Vector2(0,0)
var spit_scene = preload("res://scenes/spit.tscn")

@export var health: int = 3:
	set(value):
		health = value
		health_sprite.frame = value
	get():
		return health


func _on_ready():
	set_sprite('default')
	original_position = position
	health_sprite.frame = 3


func _physics_process(delta):
	if not is_on_floor():
		velocity.y += gravity * delta

	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		
	var direction = Input.get_axis("move_left", "move_right")
	if Input.is_action_just_released("shoot"):
		spit($".")
	if Input.is_action_pressed("shoot"):
		pointer_sprite.show()
		if spit_power_time < 0.5:
			pointer_sprite.frame = 0
		elif spit_power_time < 1.0:
			pointer_sprite.frame = 1
		else:
			pointer_sprite.frame = 2
		if spit_power_time < 1.0:
			spit_power_time += delta
	
	if direction:
		body_sprite.flip_h = direction == -1
		mouth_sprite.flip_h = direction == -1
		velocity.x = direction * SPEED
		pointer_sprite.offset.x = 32
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	if !is_on_floor():
		body_sprite.play("jump")
		if !is_spitting:
			mouth_sprite.play("jump")
	elif direction:
		body_sprite.play("walk")
		if !is_spitting:
			mouth_sprite.play("walk")
	else:
		body_sprite.play("idle")
		if !is_spitting:
			mouth_sprite.play("idle")
	
	pointer_sprite.rotation = get_local_mouse_position().normalized().angle()
	
	move_and_slide()


func increment_health(amount):
	health += amount


func set_sprite(type):
	var flip_h = body_sprite.flip_h
	if type == 'dark':
		body_sprite.hide()
		body_sprite = $DarkSprite
		body_sprite.show()
	elif type == 'light':
		body_sprite.hide()
		body_sprite = $LightSprite
		body_sprite.show()
	elif type == 'spidermxn':
		body_sprite.hide()
		body_sprite = $SpidermxnSprite
		body_sprite.show()
	else:
		body_sprite.hide()
		body_sprite = $DefaultSprite
		body_sprite.show()
	
	body_sprite.flip_h = flip_h


func spit(player):
	var new_spit = spit_scene.instantiate()
	new_spit.position.x = player.position.x
	new_spit.position.y = player.position.y
	new_spit.velocity = get_local_mouse_position().normalized() * (new_spit.SPEED + spit_power_time * 350)
	body_sprite.play("spit")
	mouth_sprite.play("spit")
	mouth_sprite.connect("animation_finished", spit_end)
	is_spitting = true
	quack1.play()
	player.add_sibling(new_spit)
	spit_power_time = 0.0
	pointer_sprite.hide()


func spit_end():
	mouth_sprite.play("idle")
	body_sprite.frame = 0
	mouth_sprite.frame = 0
	is_spitting = false
	mouth_sprite.disconnect("animation_finished", spit_end)
