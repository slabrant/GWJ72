extends Area2D

@onready var level_manager = %Manager
@onready var timer = $Timer
@onready var is_firing = false
@onready var rng = RandomNumberGenerator.new()
@onready var sprite = $AnimatedSprite2D
@onready var GAME_MANAGER = get_node("/root/Level/Manager")

func _ready():
	rng.randomize()
	timer.start()
	sprite.hide()


func _on_body_entered(body):
	if 0 < timer.time_left and is_firing:
		level_manager.increment_score(1)
		GAME_MANAGER.increment_fire_count(-1)
		is_firing = false
		sprite.hide()


func _on_timer_timeout():
	timer.start()
	var score = GAME_MANAGER.get_score()
	var fire_count = GAME_MANAGER.get_fire_count()
	if not is_firing and rng.randf() < 0.1 and fire_count < 10:
		is_firing = true
		sprite.show()
		GAME_MANAGER.increment_fire_count(1)
