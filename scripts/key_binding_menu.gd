extends Window


func _on_window_input(event: InputEvent) -> void:
	if event.is_pressed():
		# InputMap.action_add_event("move_left", event)
		print(event.as_text())
	pass # Replace with function body.
