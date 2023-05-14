extends Area2D



func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		var min_m = get_tree().current_scene.get_meta("min")
		var mid_m = get_tree().current_scene.get_meta("mid")
		var max_m = get_tree().current_scene.get_meta("max")
		Events.win.emit(Events.get_rank(min_m, mid_m, max_m, body.moves))
		for node in get_tree().get_nodes_in_group("goal"):
			node.set_deferred("monitoring", false)
