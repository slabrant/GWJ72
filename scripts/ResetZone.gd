extends CollisionShape2D
@onready var GAME_MANAGER = get_node("/root/Level/Manager")


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_area_2d_body_entered(body):
	if body.name == 'Player':
		body.health -=1
		body.position = body.original_position
		if body.health < 1:
			get_tree().reload_current_scene()
	else:
		body.queue_free()
