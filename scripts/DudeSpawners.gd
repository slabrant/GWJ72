extends Node2D

@onready var level_manager = %Manager
@onready var timer = $Timer
@onready var is_firing = false
@onready var rng = RandomNumberGenerator.new()
@onready var GAME_MANAGER = get_node("/root/Level/Manager")
var dude = preload("res://scenes/dude.tscn")


func _ready():
	rng.randomize()
	timer.start()


func _on_timer_timeout():
	timer.start()
	var score = GAME_MANAGER.get_score()
	var dude_count = GAME_MANAGER.get_dude_count()
	#if rng.randf() < (score * 0.1) + 1 and dude_count < 10:
	if rng.randf() < 0.2 and dude_count < 10:
		var new_dude = dude.instantiate()
		new_dude.position.x = $".".position.x
		new_dude.position.y = $".".position.y
		$".".add_sibling(new_dude)
		GAME_MANAGER.increment_dude_count(1)
