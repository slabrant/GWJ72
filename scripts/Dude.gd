extends CharacterBody2D

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
@onready var rng = RandomNumberGenerator.new()
@onready var sprite = $DefaultSprite
@onready var ray_right = $RayCastRight
@onready var ray_down_right = $RayCastDownRight
@onready var ray_left = $RayCastLeft
@onready var ray_down_left = $RayCastDownLeft
@onready var is_wet = false
@onready var direction = 1
@onready var GAME_MANAGER = get_node("/root/Level/Manager")
@onready var clumsiness_rate = 0.00
@onready var will_fall = false
const SPEED = 30.0
const JUMP_SPEED = 300.0


func _on_ready():
	rng.randomize()
	if rng.randf() < 0.5:
		direction = -1


func _physics_process(delta):
	if not is_on_floor():
		velocity.y += gravity * delta
	
	if ray_right.is_colliding():
		direction = -1
	elif ray_left.is_colliding():
		direction = 1
	
	if is_on_floor():
		if !ray_down_left.is_colliding() and !ray_down_right.is_colliding():
			velocity.y = -JUMP_SPEED
			clumsiness_rate += 0.08
			will_fall = clumsiness_rate < rng.randf()
		elif ((!ray_down_left.is_colliding() or !ray_down_right.is_colliding()) and not (ray_down_left.is_colliding() and ray_down_right.is_colliding())) and will_fall:
			velocity.y = -JUMP_SPEED
	
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	move_and_slide()


func _on_area_2d_body_entered(body):
	body.splash()
	if not is_wet:
		get_node("/root/Level/Manager").increment_score(-1)
		get_mad()
		is_wet = true


func get_mad():
	sprite.hide()
	sprite = $MadSprite
	sprite.show()


func _on_tree_exited():
	GAME_MANAGER.increment_dude_count(-1)
