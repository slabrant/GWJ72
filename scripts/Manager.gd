extends Node

var score = 0
@onready var label = $ScoreLabel
@onready var player = %Player
@onready var dude_count = 0
@onready var fire_count = 0


func _on_ready():
	label.text = "Score: " + str(score)


func increment_score(amount):
	score += amount
	label.text = "Score: " + str(score)
	if score <= -10:
		player.set_sprite('dark')
	elif 10 <= score:
		player.set_sprite('light')
	else:
		player.set_sprite('default')


func increment_dude_count(amount):
	dude_count += amount
	print(dude_count)


func increment_fire_count(amount):
	fire_count += amount


func get_score():
	return score


func get_dude_count():
	return dude_count


func get_fire_count():
	return fire_count
